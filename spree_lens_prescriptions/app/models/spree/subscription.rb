class Spree::Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :credit_card

  scope :pending, -> { where(:status => :pending) }
  scope :active, -> { where(:status => :active) }
  scope :canceled, -> { where(:status => :canceled) }

  attr_accessible :period, :status

  def start!(source, bill_address)
    if status.to_s == 'pending'
      r = Spree::PaymentMethod.first.provider.recurring(price*100.round, source, 
        arb_options.merge(:billing_address => bill_address.try(:active_merchant_hash).merge({:first_name => bill_address.firstname, 
                                                                                            :last_name => bill_address.lastname})))
      if r.success?
        self.arb_subscription_id = r.params['subscription_id']
        self.status = :active
        self.credit_card_id = source.id
        save
        Spree::SubscriptionMailer.confirm_email(self).deliver
        true
      else
        self.status = :invalid
        self.response_text = r.params['text']
        self.credit_card_id = source.id
        # self.params['text']
        save
        false
      end
    end
  end

  def cancel!
    if status.to_s == 'active' && arb_subscription_id
      r = Spree::PaymentMethod.first.provider.cancel_recurring(arb_subscription_id)
      if r.success?
        self.status = :canceled
        save
        Spree::SubscriptionMailer.cancel_email(self).deliver
      end
    end
  end

  def update_status!
    if arb_subscription_id
      r = Spree::PaymentMethod.first.provider.status_recurring(arb_subscription_id)
      if r.success?
        self.status = r.params['status']
        save
      end
    end
  end

  def arb_options
    opts = {}
    case period.to_s
    when 'month'
      opts[:interval] = {:unit => :months, :length => 1 }
      opts[:duration] = {:start_date => started_at.iso8601, :occurrences => 1000 } # forever
      # opts[:end_of_period] = next_billing + 11.months
    when 'year'
      opts[:interval] = {:unit => :months, :length => 12 }
      opts[:duration] = {:start_date => started_at.iso8601, :occurrences => 100 } # forever
      # opts[:end_of_period] = next_billing
    end
    opts
  end

  def price
    case period.to_s
    when 'month'
      Spree::Config.lp_subscription_monthly_price
    when 'year'
      Spree::Config.lp_subscription_annual_price
    end
  end

  def self.need_to_be_notified_about_expiration
    where(:status => :active).where(%q[
 extract(year from created_at) > :year
 and if (extract(day from spree_subscriptions.created_at)=1, 
   if (extract(month from spree_subscriptions.created_at) = 1, 12, extract(month from '2013-01-01') - 1), 
     extract(month from spree_subscriptions.created_at)) = :month
    ], :year => Date.today.year, :month => Date.today.month)
  end

  def self.notify_subscribers_about_expiration
    need_to_be_notified_about_expiration.each do |s|
      Spree::SubscriptionMailer.expiration_email(s).deliver
    end
  end

  def active?
    status.to_s == 'active'
  end

  def self.update_statuses
    active.each do |s|
      s.update_status!
      Spree::SubscriptionMailer.cancel_email(s).deliver unless s.active?
    end
  end

  def started_at
    if created_at.day == 1
      created_at.to_date
    else 
      created_at.to_date.end_of_month + 1.day
    end
  end
end

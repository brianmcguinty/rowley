module Spree
  User.class_eval do
    validates_presence_of :firstname, :lastname
    attr_accessible :firstname, :lastname
    
    attr_reader :new_email 
    attr_accessor :new_email_confirmation
    attr_accessible :new_email, :new_email_confirmation

    validates_presence_of   :new_email, :if => :new_email_required?
    # validates_uniqueness_of :new_email, :allow_blank => true, :if => :email_changed?
    validate :unique_new_email
    validates_format_of     :new_email, :with  => email_regexp, :allow_blank => true
    validates_confirmation_of :new_email, :if => :email_required?


    def full_name
      "#{firstname} #{lastname}".strip
    end

    def new_email=(value)
      @new_email = value
      self.email = value if value.present?
    end

    def new_email_required?
      new_email.present? || new_email_confirmation.present?
    end

    def unique_new_email
      if self.class.where(:email => @new_email).where('spree_users.id != ?', id).any?
        errors.add(:new_email, 'Not unique email address')
      end
    end

    def previous_valid_cards
      Spree::CreditCard.joins(:payments => :order).
        where('spree_orders.user_id = ?', id).
        where('spree_orders.state = "complete"').
        where('spree_credit_cards.encrypted_stored_number is not null').
        where('spree_credit_cards.year > year(curdate()) or (spree_credit_cards.year = year(curdate()) and spree_credit_cards.month >= month(curdate()))')
    end

    def last_valid_card
      previous_valid_cards.order(:completed_at).last
    end

    def last_incomplete_normal_order
      spree_orders.ordinary.incomplete.order('created_at DESC').last
    end

    def last_incomplete_hto_order
      spree_orders.hto.incomplete.order('created_at DESC').last
    end

  end
end

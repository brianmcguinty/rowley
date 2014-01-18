module Spree
  User.class_eval do
    has_many :lens_prescriptions, :as => :prescription_container
    has_many :subscriptions

    def active_subscription
      subscriptions.active.last
    end

    def register_subscription(period, source)
      s = subscriptions.new(:period => period, :status => :pending)
      s.save
      s.start!(source, bill_address || orders.complete.last.bill_address)
    end
  end
end

module Spree
  Order.class_eval do

    require 'spree_mail_chimp'
    include SpreeMailChimp::SharedMethods

    attr_accessor :use_cc
    cattr_accessor :controller
    cattr_accessor :ignore_adjustments_lock
    attr_accessor :email_required

    attr_accessible :hto, :email_required

    scope :hto, -> { where('hto = 1') }
    scope :ordinary, -> { where('hto = 0') }
    scope :not_canceled, -> {where('spree_orders.state != "canceled"')}

    register_update_hook :update_hto_state

    def self.define_state_machine!
      # Needs to be an ordered hash to preserve flow order
      self.checkout_steps = ActiveSupport::OrderedHash.new
      self.next_event_transitions = []
      self.previous_states = [:cart]

      # Build the checkout flow using the checkout_flow defined either
      # within the Order class, or a decorator for that class.
      #
      # This method may be called multiple times depending on if the
      # checkout_flow is re-defined in a decorator or not.
      instance_eval(&checkout_flow)

      klass = self

      # To avoid a ton of warnings when the state machine is re-defined
      StateMachine::Machine.ignore_method_conflicts = true
      # To avoid multiple occurrences of the same transition being defined
      # On first definition, state_machines will not be defined
      state_machines.clear if respond_to?(:state_machines)
      state_machine :state, :initial => :cart do
        klass.next_event_transitions.each { |t| transition(t.merge(:on => :next)) }

        # Persist the state on the order
        after_transition do |order|
          order.state = order.state
          order.save
        end

        event :cancel do
          transition :to => :canceled, :if => :allow_cancel?
        end

        event :return do
          transition :to => :returned, :from => :awaiting_return, :unless => :awaiting_returns?
        end

        event :resume do
          transition :to => :resumed, :from => :canceled, :if => :allow_resume?
        end

        event :authorize_return do
          transition :to => :awaiting_return
        end

        before_transition :to => :complete do |order|
          begin
            order.process_payments! if order.payment_required?
          rescue Spree::Core::GatewayError
            !!Spree::Config[:allow_checkout_on_gateway_error]
          end
        end

        before_transition :to => :delivery, :do => :remove_invalid_shipments!
        # before_transition :to => :lens_prescription, :do => :init_prescription_and_subscription

        after_transition :to => :complete, :do => :finalize2!
        after_transition :to => :order, :do => :create_tax_charge! # :to => :shipping ???
        after_transition :to => :resumed,  :do => :after_resume
        after_transition :to => :canceled, :do => :after_cancel

        after_transition :from => :shipping,  :do => :create_shipment!

        after_transition :to => :complete,  :do => :consume_users_credit
      end
    end

    # consume users store credit once the order has completed.
    #state_machine.after_transition :to => :complete,  :do => :consume_users_credit

    def self.checkout_flow(&block)
      if block_given?
        @checkout_flow = block
        define_state_machine!
      else
        @checkout_flow
      end
    end

    checkout_flow do
      go_to_state :lens_prescription, :if => lambda { |order| !order.hto? }
      go_to_state :shipping
      go_to_state :billing, :if => lambda { |order|
        # Fix for #2191
        if order.shipping_method
          order.create_shipment!
          order.update_totals
        end
        order.payment_required?
      }
      go_to_state :order
      go_to_state :complete, :if => lambda { |order| (order.payment_required? && order.payments.exists?) || !order.payment_required? }
    end

    def init_prescription_and_subscription(options = {})
      if hto?
        self.lens_meta_prescription ||= LensMetaPrescription.default_demo
      else
        self.lens_meta_prescription ||= LensMetaPrescription.default(user, options)
        if user.present? && (active_subscription = user.subscriptions.active.first)
          unless (la = lens_adjustment) && la.locked
            self.order_subscription_discount ||= OrderSubscriptionDiscount.new(:subscription => active_subscription, :discount_percent => Spree::Config.lp_subscription_discount_percent)
          end
        end
      end
      # save
    end

    attr_accessible :use_shipping, :subscribe_to_news, :store_id
    attr_accessor :use_shipping

    before_validation :clone_shipping_address, :if => :use_shipping?
    # after_save :subscribing_to_news

    def has_available_shipment
      return unless shipping?
      return unless ship_address && ship_address.valid?
      errors.add(:base, :no_shipping_methods_available) if available_shipping_methods.empty?
    end

    def use_shipping?
      @use_shipping == true || @use_shipping == "true" || @use_shipping == "1"
    end

    def clone_shipping_address
      if ship_address and self.bill_address.nil?
        self.bill_address = ship_address.clone
      else
        self.bill_address.attributes = ship_address.attributes.except('id', 'updated_at', 'created_at')
      end
      true
    end

    def create_shipment!
      shipping_method(true)
      if shipment.present?
        shipment.update_attributes!(:shipping_method => shipping_method)
        shipment.update_attributes!(:address => self.ship_address) if (self.ship_address.present? && self.ship_address.valid?)
      else
        self.shipments << Shipment.create!({:order => self,
                                            :shipping_method => shipping_method,
                                            #:address => self.ship_address,
                                            :inventory_units => self.inventory_units}, :without_protection => true)
      end
    end

    def subscribing_to_news
      subscribe_email ship_address.email if subscribe_to_news
    rescue
      false
    end

    def subscribing_to_rc_news
      subscribe_email_to_list user.email, 'rowley-care' if user.present?
    rescue
      false
    end
    
    def finalize2!
      finalize!
      save_or_update_addresses
      add_store_credits if user.present?
      subscribing_to_news
      subscription_result = register_subscription unless hto?
      subscribing_to_rc_news if subscription_result
      auto_verify_prescription
      send_prescription_to_lab
      save_prescription_to_user unless hto?
    end

    def add_store_credits
      # Store credits will be added if coupon amount more then order total
      if promo_adjustment.present? && promo_adjustment.originator.calculator.type == 'Spree::Calculator::FlatRate'
        preferred_amount = promo_adjustment.originator.calculator.preferred_amount
        difference = preferred_amount + promo_adjustment.amount
        if difference > 0
          # Add Store Credits to current user
          Spree::StoreCredit.create(:amount => difference,
                                    :remaining_amount => difference,
                                    :reason => "remainder from coupon #{promo_adjustment.originator.promotion.code}",
                                    :user_id => user.id)
        end
      end
    end

    def auto_verify_prescription
      lens_meta_prescription.auto_verify
    end

    def save_prescription_to_user
      lens_meta_prescription.lens_prescription.save_to_user
    end

    def register_subscription
      if lens_meta_prescription.purchase_subscription.present?
        s = user.subscriptions.new(:period => lens_meta_prescription.purchase_subscription, :status => :pending)
        s.save
        Spree::LensMetaPrescription.where(:id => lens_meta_prescription.id).update_all(:subscription_id => s.id)
        s.start!(payment.source, bill_address)
      end
    end

    def save_or_update_addresses
      if user.present?
        user.ship_address = ship_address
        user.bill_address = bill_address
        user.save(:validate => false)
      end
    end

    ## now we store cc to db (encrypted)
    # def rollup_stored_source(source) # restore credit card from session
    #   if controller &&
    #       (session_source_params = controller.session[:order_payment_source_params]).present? &&
    #       session_source_params[:order_id] == id &&
    #       source.number.blank?
    #     source.attributes = session_source_params[:source_params]
    #     source.save
    #   end
    #   source
    # end

    def self.notify_about_incomplete_prescriptions(for_date)
      Spree::LensPrescriptionMailer.details_required_list_email(for_date).deliver
    end

    def self.notify_about_verify_or_pending_prescriptions
      if Spree::Order.complete.not_canceled.contains_verify_or_pending_prescription.any?
        Spree::LensPrescriptionMailer.verify_or_pending_list_email.deliver
      end
    end

    # override method to generate order numbers to compatibility with ShipWorks
    def generate_order_number
      record = true
      while record
        random = "#{Array.new(9) { rand(9) }.join}"
        record = self.class.where(:number => random).first
      end
      self.number = random if self.number.blank?
      self.number
    end

    def display_shipping_total
      Spree::Money.new(ship_total, { :currency => currency })
    end

    def display_subtotal
      Spree::Money.new(item_total+adjustment_total, { :currency => currency })
    end

    def display_tax_total
      Spree::Money.new(tax_total, { :currency => currency })
    end

    def display_hto_total
      Spree::Money.new(0, { :currency => currency })
    end

    def promo_adjustment
      adjustments.where(:originator_type => 'Spree::PromotionAction').eligible.first
    end

    def merge!(order)
      order.line_items.each do |line_item|
        next unless line_item.currency == currency
        break if hto_sufficient_items?
        current_line_item = self.line_items.find_by_variant_id(line_item.variant_id)
        if current_line_item 
          unless hto?
            current_line_item.quantity += line_item.quantity
            current_line_item.save
          end
        else
          line_item.order_id = self.id
          line_item.save
        end
      end
      # So that the destroy doesn't take out line items which may have been re-assigned
      order.line_items.reload
      order.destroy
    end

    def update_hto_state
      if hto?
        self.hto_state = 
          if completed? && !canceled?
            # maxs: now order becomes 'returned' if all it's inventory units are returned; payment state doesn't matter.
            if inventory_units.any?(&:returned?) && !inventory_units.any?(&:shipped?) #&& !payments.any?(&:pending?)
              'returned'
            elsif payments.any?(&:completed?)
              'paid'
            elsif shipments.any?(&:shipped?)
              if hto_overdue_days > 0
                'overdue'
              elsif hto_warning_days > 0
                'pending_return'
              elsif hto_delivered_days > 0
                'delivered'
              else
                'shipped'
              end
            else 
              'ready'
            end
          else
            'unavailable'
          end
      end
      update_attributes_without_callbacks({
        :hto_state => hto_state
      })
      if hto_state_changed?
        state_changed('hto')
        case hto_state
        when 'delivered'
          HtoMailer.delivered_email(self).deliver
        when 'pending_return'
          HtoMailer.warning_email(self).deliver
        when 'overdue' 
          HtoMailer.overdue_email(self).deliver
        when 'returned' 
          HtoMailer.returned_email(self).deliver
        when 'paid' 
          HtoMailer.paid_email(self).deliver
        end
      end
    end

    def hto_warning_days
      [days_after_shipping - Spree::Config.hto_warning_days, 0].max
    end

    def hto_delivered_days
      [days_after_shipping - Spree::Config.hto_delivered_days, 0].max
    end

    def hto_overdue_days
      [days_after_shipping - Spree::Config.hto_overdue_days, 0].max
    end

    def days_after_complete
      if completed_at.present?
        (Date.today - completed_at.to_date).to_i
      else
        0
      end
    end

    def days_after_shipping
      if shipped_at
        (Date.today - shipped_at.to_date).to_i
      else
        0
      end
    end

    def shipped_at
      shipments.shipped.minimum(:shipped_at)
    end

    def hto_completed?
      hto_state.in? 'returned', 'unavailable', 'paid'
    end

    def self.hto_completed
      hto.where(:state => [:returned, :unavailable, :paid])
    end

    def self.hto_overdue
      where("#{table_name}.hto_state = 'overdue'")
    end

    def self.hto_not_completed
      hto.where('spree_orders.hto_state not in ("returned", "unavailable", "paid")')
    end

    def self.hto_ready_for_auto_capture
      hto_enabled_auto_capture.where('hto_state = "overdue"').where('datediff(:today, date((select min(shipped_at) from spree_shipments where order_id = spree_orders.id))) >= :hto_auto_capture_days', :today => Date.today, :hto_auto_capture_days => Spree::Config.hto_auto_capture_days)
    end

    # def self.hto_ready_for_auto_capture
    #   hto.where('hto_state = "overdue"').where('datediff(CURDATE(), date(completed_at)) >= ?', Spree::Config.hto_auto_capture_days)
    # end

    def self.update_hto_states
      hto_not_completed.each { |o| o.update_hto_state }
    end

    def self.hto_auto_capture_overdues
      manual = []
      hto_ready_for_auto_capture.each do |o| 
        unless o.hto_auto_capture
          manual << o
        end
      end 
      if manual.present?
        Spree::HtoMailer.capture_manually_email(manual).deliver
      end
    end

    def hto_auto_capture
      if odp = one_dollar_payment
        if odp.pending? && payments.count == 1 && total != 1
          odp.void_transaction!
          new_payment = payments.new
          new_payment.source = odp.source
          new_payment.amount = total
          new_payment.payment_method = odp.payment_method
          new_payment.save!
          new_payment.purchase!
          true
        else
          false
        end
      else
        payments.pending.each { |p| p.capture! }
      end
    rescue
      false
    end

    def one_dollar_payments
      payments.where(:amount => 1)
    end

    def one_dollar_payment
      one_dollar_payments.first
    end

    def checkout_allowed?
      if hto?
        hto_sufficient_items?
      else
        line_items.count > 0
      end
    end

    def hto_sufficient_items?
      hto? && item_count == Spree::Config.hto_items
    end

    def hto_start_at
      shipped_at + Spree::Config.hto_delivered_days.days
    end

    def hto_finish_at
      shipped_at + Spree::Config.hto_overdue_days.days
    end

    def hto_auto_capture_at
      shipped_at + Spree::Config.hto_auto_capture_days.days
    end

    def hto_overdue?
      hto_state == 'overdue'
    end

    def self.hto_enabled_auto_capture
      hto.where(:hto_disabled_auto_capture => false)
    end

    def self.hto_disabled_auto_capture
      hto.where(:hto_disabled_auto_capture => true)
    end

    def hto_disable_auto_capture
      update_attribute(:hto_disabled_auto_capture, true)
    end

    def require_email
      email_required || !(new_record? or state == 'cart')
    end

  end

end

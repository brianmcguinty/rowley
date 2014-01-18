module Spree
  class HtoCheckoutController < Spree::StoreController
    helper :all

    ssl_required

    before_filter :load_order
    before_filter :ensure_valid_state
    before_filter :associate_user
    rescue_from Spree::Core::GatewayError, :with => :rescue_from_spree_gateway_error

    respond_to :html

    before_filter :check_authorization
    before_filter :check_registration, :except => [:registration, :update_registration]

    helper 'spree/users'

    def registration
      @user = Spree::User.new
    end

    def update_registration
      fire_event("spree.user.signup", :order => current_hto_order)
      # hack - temporarily change the state to something other than cart so we can validate the order email address
      current_hto_order.state = current_hto_order.checkout_steps.first
      if current_hto_order.update_attributes(params[:order])
        redirect_to hto_checkout_path
      else
        @user = Spree::User.new
        render 'registration'
      end
    end

    def before_shipping
      @order.init_prescription_and_subscription
      @order.ship_address ||= (spree_current_user.present? && spree_current_user.ship_address.present?) ? spree_current_user.ship_address  : Address.default
      if @order.available_shipping_methods.count >= 1
        @order.shipping_method = @order.available_shipping_methods.first
        @order.create_shipment!
        @order.update_totals
      end
    end

    def before_billing
      @order.bill_address ||= (@order.bill_address.nil? && spree_current_user.present? && spree_current_user.bill_address.present?) ? spree_current_user.bill_address : Address.default
    end

    # Updates the order and advances to the next state (when possible.)
    # Overriden by the promo gem if it exists. 
    def update
      op = object_params
      if op && op[:payments_attributes]
        @order.payments.where('spree_payments.state = "checkout"').destroy_all
      end
      # binding.pry
      if @order.update_attributes(op)

        fire_event('spree.checkout.update')

        if @order.next
          state_callback(:after)
        else
          flash[:error] = t(:payment_processing_failed)
          respond_with(@order, :location => hto_checkout_state_path(@order.state))
          return
        end

        if @order.state == 'complete' || @order.completed?
          flash.notice = t(:order_processed_successfully)
          flash[:commerce_tracking] = 'nothing special'
          respond_with(@order, :location => completion_route)
        else
          respond_with(@order, :location => hto_checkout_state_path(@order.state))
        end
      else
        respond_with(@order) { |format| format.html { render :edit } }
      end
    end

    private
      def check_authorization
        authorize!(:edit, current_hto_order, session[:access_hto_token])
      end

      def check_registration
        return unless Spree::Auth::Config[:registration_step]
        return if spree_current_user or current_hto_order.email
        store_location
        redirect_to spree.hto_checkout_registration_path
      end

      def completion_route
        return order_path(@order) if spree_current_user
        spree.token_order_path(@order, @order.token)
      end

      def ensure_valid_state
        unless skip_state_validation?
          if (params[:state] && !@order.checkout_steps.include?(params[:state])) ||
             (!params[:state] && !@order.checkout_steps.include?(@order.state))
            @order.state = 'cart'
            redirect_to hto_checkout_state_path(@order.checkout_steps.first)
          end
        end
      end

      def skip_state_validation?
        %w(registration update_registration).include?(params[:action])
      end

      def load_order
        @order = current_hto_order
        redirect_to cart_path(:hto => true) and return unless @order and @order.checkout_allowed?
        raise_insufficient_quantity and return if @order.insufficient_stock_lines.present?
        redirect_to cart_path(:hto => true) and return if @order.completed?
        @order.state = params[:state] if params[:state]
        state_callback(:before)
      end

      # Provides a route to redirect after order completion
      def completion_route
        order_path(@order, :checkout_complete => true)
      end

      def object_params
        # For payment step, filter order parameters to produce the expected nested attributes for a single payment and its source, discarding attributes for payment methods other than the one selected
        if @order.billing?
          if params[:use_cc] == 'use_stored'
            last_cc = @order.user.last_valid_card
            params[:order][:payments_attributes].first[:source_attributes] = {
              :number => last_cc.number,
              :verification_value => last_cc.verification_value,
              :first_name => last_cc.first_name,
              :last_name => last_cc.last_name,
              :month => last_cc.month,
              :year => last_cc.year
            }
          elsif params[:payment_source].present? && source_params = params.delete(:payment_source)[params[:order][:payments_attributes].first[:payment_method_id].underscore]
            params[:order][:payments_attributes].first[:source_attributes] = source_params
            # session[:order_payment_source_params] = {:order_id => @order.id, :source_params => source_params}
          end
          if (params[:order][:payments_attributes])
            params[:order][:payments_attributes].first[:amount] = 1.0 # one-dollar hto
          end
        end
        params[:order]
      end

      def raise_insufficient_quantity
        flash[:error] = t(:spree_inventory_error_flash_for_insufficient_quantity)
        redirect_to cart_path
      end

      def state_callback(before_or_after = :before)
        method_name = :"#{before_or_after}_#{@order.state}"
        send(method_name) if respond_to?(method_name, true)
      end

      def after_complete
        session[:hto_order_id] = nil
      end

      def rescue_from_spree_gateway_error
        flash[:error] = t(:spree_gateway_error_flash_for_checkout)
        render :edit
      end
  end
end

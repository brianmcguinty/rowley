module Spree
  CheckoutController.class_eval do
    ssl_required

    def before_shipping
      @order.ship_address ||= (spree_current_user.present? && spree_current_user.ship_address.present?) ? spree_current_user.ship_address  : Address.default
      # @order.ship_address.save(:validate => false)
      # @order.save(:validate => false)
      if @order.available_shipping_methods.count >= 1
        @order.shipping_method = @order.available_shipping_methods.first
        @order.create_shipment!
        @order.update_totals
      end
    end

    def before_billing
      @order.bill_address ||= (@order.bill_address.nil? && spree_current_user.present? && spree_current_user.bill_address.present?) ? spree_current_user.bill_address : Address.default
      # @order.bill.save(:validate => false)
      # @order.save(:validate => false)
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
          params[:order][:payments_attributes].first[:amount] = @order.total
        end
      end
      params[:order]
    end

    def completion_route
      order_path(@order, :checkout_complete => true)
    end

    def update
      op = object_params
      if op && op[:payments_attributes]
        @order.payments.where('spree_payments.state = "checkout"').destroy_all
      end
      respond_to do |wants|
        wants.js do
          # order_total_before = @order.total
          @order.attributes = op
          @order.lens_meta_prescription.replace_lens_prescription_with_stored
          @order.save(:validate => false)
          fire_event('spree.checkout.update')
          @order.reload
          # @total_changed = @order.total != order_total_before
        end
        wants.html do
          if @order.update_attributes(op)
            fire_event('spree.checkout.update')

            unless apply_coupon_code
              respond_with(@order) { |format| format.html { render :edit } }
              return
            end

            if @order.next
              state_callback(:after)
            else
              flash[:error] = t(:payment_processing_failed)
              respond_with(@order, :location => checkout_state_path(@order.state))
              return
            end

            if @order.state == "complete" || @order.completed?
              flash.notice = t(:order_processed_successfully)
              flash[:commerce_tracking] = "nothing special"
              respond_with(@order, :location => completion_route)
            else
              respond_with(@order, :location => checkout_state_path(@order.state))
            end
          else
            respond_with(@order) { |format| format.html { render :edit } }
          end
        end
      end
    end


    #def update_shipping_methods
    #  if @order.update_attributes(params[:order])
    #    @order.create_shipment!
    #    @order.update_totals
    #  end
    #end

  end
end

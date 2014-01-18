module Spree
  CheckoutController.class_eval do
    respond_to :js, :only => :update

    def before_lens_prescription
      @order.init_prescription_and_subscription
    end

    # def update
    #   op = object_params
    #   if op && op[:payments_attributes]
    #     @order.payments.where('spree_payments.state = "checkout"').destroy_all
    #   end
    #   respond_to do |wants|
    #     wants.js do
    #       # order_total_before = @order.total
    #       @order.attributes = op
    #       @order.lens_meta_prescription.replace_lens_prescription_with_stored
    #       @order.save(:validate => false)
    #       fire_event('spree.checkout.update')
    #       @order.reload
    #       # @total_changed = @order.total != order_total_before
    #     end
    #     wants.html do
    #       if @order.update_attributes(op)
    #         fire_event('spree.checkout.update')

    #         unless apply_coupon_code
    #           respond_with(@order) { |format| format.html { render :edit } }
    #           return
    #         end

    #         if @order.next
    #           state_callback(:after)
    #         else
    #           flash[:error] = t(:payment_processing_failed)
    #           respond_with(@order, :location => checkout_state_path(@order.state))
    #           return
    #         end

    #         if @order.state == "complete" || @order.completed?
    #           flash.notice = t(:order_processed_successfully)
    #           flash[:commerce_tracking] = "nothing special"
    #           respond_with(@order, :location => completion_route)
    #         else
    #           respond_with(@order, :location => checkout_state_path(@order.state))
    #         end
    #       else
    #         respond_with(@order) { |format| format.html { render :edit } }
    #       end
    #     end
    #   end
    # end

    # def change_glasses_type
    #   @order.lens_meta_prescription.update_attribute(:glasses_type, params[:glasses_type])
    #   respond_to do |wants|
    #     wants.js
    #   end
    # end

    # def change_prescription_input_method
    # end
  end
end

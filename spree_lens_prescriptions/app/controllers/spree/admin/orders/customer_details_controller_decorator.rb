module Spree
  module Admin
    module Orders
      CustomerDetailsController.class_eval do
        def update
          if @order.update_attributes(params[:order])
            shipping_method = @order.available_shipping_methods(:front_end).first
            if shipping_method
              @order.shipping_method = shipping_method

              if params[:user_id].present?
                @order.user_id = params[:user_id]
                @order.user true
              end
              @order.save
              @order.create_shipment!
              flash[:success] = t('customer_details_updated')
              redirect_to admin_order_lens_prescription_url(@order)
            else
              flash[:error] = t('errors.messages.no_shipping_methods_available')
              redirect_to admin_order_customer_path(@order)
            end
          else
            render :action => :edit
          end

        end
      end
    end
  end
end

module Spree
  module Admin
    OrdersController.class_eval do
      helper 'spree/admin/lens_meta_prescriptions'

      before_filter :load_order_by_id, :only => [:send_prescription_to_lab]

      respond_to :html, :rx

      def show
        respond_with(@order) do |format|
            format.html { render }
            format.rx {
              response.headers['Content-Disposition'] = "attachment; filename=\"299002-299-#{@order.number}.rx\""
              if @order.lens_meta_prescription.glasses_type == 'frames_sunglasses' && @order.lens_meta_prescription.demo?
                render 'spree/admin/orders/demo_lenses.rx.erb'
              end
            }
          end

      end

      def send_prescription_to_lab
        @order.send_prescription_to_lab
        flash[:notice] = t(:lens_prescription_lab_email_sended)
        redirect_to :back
        rescue ActionController::RedirectBackError
          redirect_to admin_order_lens_prescription_url(@order)
      end
    end
  end
end


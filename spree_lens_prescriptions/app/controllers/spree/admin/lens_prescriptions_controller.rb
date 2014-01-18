module Spree
  module Admin
    class LensPrescriptionsController < Spree::Admin::BaseController
      before_filter :load_order
      ensure_order_lock :except => [:show]
      respond_to :html

      def show
        edit
        render :action => :edit
      end

      def edit
        @order.init_prescription_and_subscription(:prescription_input_method => :enter_new_prescription)
        # @order.lens_meta_prescription ||= LensMetaPrescription.default(nil, :prescription_input_method => :enter_new_prescription)
        # if @order.user.present? && !@order.complete? && (active_subscription = @order.user.subscriptions.active.first)
        #   @order.order_subscription_discount ||= OrderSubscriptionDiscount.new(:subscription => active_subscription, :discount_percent => Spree::Config.lp_subscription_discount_percent)
        # end
      end

      def update
        @order.attributes = params[:order]
        Spree::Order.ignore_adjustments_lock = params[:recalculate_adjustments] == '1'
        @order.lens_meta_prescription.lens_prescription.patient_birth_date = Date.strptime(params[:order][:lens_meta_prescription_attributes][:lens_prescription_attributes][:patient_birth_date], '%m/%d/%Y') rescue nil
        if @order.save
          @order.update!
          flash[:success] = t('lens_prescription.updated')
          # redirect_to edit_admin_order_customer_path(@order, @order.shipment)
          if @order.complete?
            redirect_to edit_admin_order_lens_prescription_path(@order)
          else
            redirect_to edit_admin_order_shipment_path(@order, @order.shipment)
          end
        else
          render :action => :edit
        end
      end

      # end

      # private

      def load_order
        @order = Order.find_by_number!(params[:order_id])
        authorize! params[:action], @order
      end

      def fire
        # TODO - possible security check here but right now any admin can before any transition (and the state machine
        # itself will make sure transitions are not applied in the wrong state)
        event = params[:e]
        if @order.lens_meta_prescription.send("#{event}")
          flash[:success] = t(:order_updated)
        else
          flash[:error] = t(:cannot_perform_operation)
        end
      rescue Spree::Core::GatewayError => ge
        flash[:error] = "#{ge.message}"
      ensure
        respond_with(@order) { |format| format.html { redirect_to :back } }
      end
    end
  end
end

Spree::Admin::PaymentsController.class_eval do
  def load_data
    @amount = params[:amount] || load_order.total
    @payment_methods = Spree::PaymentMethod.available(:back_end)
    if @payment and @payment.payment_method
      @payment_method = @payment.payment_method
    else
      @payment_method = @payment_methods.first
    end
    @previous_cards = @order.credit_cards #.with_payment_profile # as we store full cc info
  end

  def create
    @payment = @order.payments.build(object_params)
    if @payment.payment_method.is_a?(Spree::Gateway) && params[:card].present? and params[:card] != 'new'
      @payment.source = Spree::CreditCard.find_by_id(params[:card])
    end

    begin
      unless @payment.save
        respond_with(@payment) { |format| format.html { redirect_to admin_order_payments_path(@order) } }
        return
      end

      if @order.completed?
        @payment.process!
        flash[:success] = flash_message_for(@payment, :successfully_created)

        respond_with(@payment) { |format| format.html { redirect_to admin_order_payments_path(@order) } }
      else
        #This is the first payment (admin created order)
        until @order.completed?
          @order.next!
        end
        flash[:success] = t(:new_order_completed)
        respond_with(@payment) { |format| format.html { redirect_to admin_order_url(@order) } }
      end

    rescue Spree::Core::GatewayError => e
      flash[:error] = "#{e.message}"
      respond_with(@payment) { |format| format.html { redirect_to new_admin_order_payment_path(@order) } }
    end
  end

end

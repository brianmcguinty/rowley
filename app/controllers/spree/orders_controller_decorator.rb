Spree::OrdersController.class_eval do
  before_filter :check_hto

  def check_hto
    @hto = params.delete(:hto)
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    if @hto
      @order = current_hto_order(true) 
      populator = Spree::HtoOrderPopulator.new(@order, current_currency)
    else
      @order = current_order(true)
      populator = Spree::OrderPopulator.new(@order, current_currency)
    end
    if populator.populate(params.slice(:products, :variants, :quantity))
      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')
      #redirect_to  :products, :show_cart => 'true'
      if @hto
        redirect_to :controller => 'products', :show_hto => 'true'
      else
        redirect_to :controller => 'products', :show_cart => 'true'
      end
      #respond_with(@order) do |format|
      #  format.html { redirect_to cart_path }
      #end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_to :back
    end
  end

  # delete line_item from cart
  def remove_item
    @order = if @hto then current_hto_order(true) else current_order(true) end
    if @order.present? && (item = @order.line_items.find_by_id(params[:id]))
      item.destroy
      fire_event('spree.order.contents_changed')
      reset_prescription(@order)
    end
    redirect_to :back
    rescue ActionController::RedirectBackError
        redirect_to root_path
  end

  def as_invoice_email
    @order = Spree::Order.find_by_number(params[:order_id])
    respond_to do |wants|
      wants.html { render 'spree/order_mailer/confirm_email', :layout => false }
    end
  end

  def as_shipping_email
    @order = Spree::Order.find_by_number(params[:order_id])
    respond_to do |wants|
      wants.html { render 'spree/shipment_mailer/shipped_email', :layout => false }
    end
  end

  def update
    @order = if @hto then current_hto_order(true) else current_order(true) end
    if @order.update_attributes(params[:order])
      render :edit and return unless apply_coupon_code

      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      reset_prescription(@order)
      respond_with(@order) do |format|
        format.html do
          if @hto
            if params.has_key?(:checkout) && @order.hto_sufficient_items?
              redirect_to hto_checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path(:hto => true)
            end
          else
            if params.has_key?(:checkout)
              redirect_to checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path
            end
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  def edit
    @order = if @hto then current_hto_order(true) else current_order(true) end
    associate_user
    if @hto
      render 'spree/hto_orders/edit'
    end
  end

  private

  def reset_prescription(order)
    unless order.item_count > 0
      order.destroy
    end
  end

end

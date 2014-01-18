Spree::Admin::OrdersController.class_eval do
  # before_filter :set_edit_by_user, :only => [:edit, :update, :fire]
  before_filter :load_order_by_order_id, :only => [:unlock]

  ensure_order_lock :except => [:index, :show, :unlock, :send_prescription_to_lab]

  # def set_edit_by_user
  #   if @order.present?
  #     @order.edit_by_user = current_user 
  #     @order.lock(current_user)
  #   end
  # end

  def unlock
    if @order.unlock(current_user)
      flash[:success] = t(:order_unlocked)
      redirect_to admin_order_path(@order)
    else
      flash[:error] = t(:cannot_unlock_order)
      redirect_to :back
    end
  end

  def load_order_by_order_id
    @order = Spree::Order.find_by_number!(params[:order_id], :include => :adjustments)
    authorize! params[:action], @order
  end
end

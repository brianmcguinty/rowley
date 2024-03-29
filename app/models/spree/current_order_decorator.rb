Spree::Core::ControllerHelpers::Order.module_eval do
  # Associate the new order with the currently authenticated user before saving
  def before_save_new_hto_order
    @current_hto_order.user ||= try_spree_current_user
  end

  def after_save_new_hto_order
    # make sure the user has permission to access the order (if they are a guest)
    return if spree_current_user
    session[:access_hto_token] = @current_hto_order.token
  end
end

Spree::Admin::Orders::CustomerDetailsController.class_eval do
  def authorize_admin
    authorize! :manage, Spree::Order
  end
end

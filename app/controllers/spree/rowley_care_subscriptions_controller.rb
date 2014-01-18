class Spree::RowleyCareSubscriptionsController < Spree::StoreController
  before_filter :auth_user
  def auth_user
    redirect_to login_url unless user_signed_in?
  end

  respond_to :html, :only => [:show]
  
  def cancel
    current_user.active_subscription.cancel!
    redirect_to root_url, :notice => 'You RC has been canceled'
  end
end

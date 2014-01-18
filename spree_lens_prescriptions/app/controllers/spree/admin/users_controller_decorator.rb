module Spree
  module Admin
    UsersController.class_eval do
      def cancel_subscription
        respond_to do |wants|
          @user = Spree::User.find(params[:user_id])
          @user.active_subscription.cancel! if @user.active_subscription.present?
          wants.html { redirect_to edit_admin_user_path(@user), :notice => 'RC has been canceled' }
        end
      end
    end
  end
end


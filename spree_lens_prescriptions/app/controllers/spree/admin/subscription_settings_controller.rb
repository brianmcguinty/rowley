module Spree
  module Admin
    class SubscriptionSettingsController < Spree::Admin::BaseController
      
      def show
        redirect_to( :action => :edit )
      end

      def update
        Spree::Config.set(params[:preferences])

        respond_to do |format|
          format.html {
            flash[:notice] = t(:subscription_settings_updated)
            redirect_to edit_admin_subscription_settings_path
          }
        end
      end
    end
  end
end

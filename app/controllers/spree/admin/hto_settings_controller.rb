module Spree
  module Admin
    class HtoSettingsController < Spree::Admin::BaseController
      
      def show
        redirect_to( :action => :edit )
      end

      def update
        Spree::Config.set(params[:preferences])

        respond_to do |format|
          format.html {
            flash[:notice] = t(:hto_settings_updated)
            redirect_to edit_admin_hto_settings_path
          }
        end
      end
    end
  end
end

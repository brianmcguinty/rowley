module Spree
  module Admin
    class SimpleSalesSettingsController < Spree::Admin::BaseController
      
      def show
        redirect_to( :action => :edit )
      end

      def update
        Spree::Variant.clear_sale_prices

        respond_to do |format|
          format.html {
            flash[:notice] = t(:sales_prices_cleared)
            redirect_to edit_admin_simple_sales_settings_path
          }
        end
      end
    end
  end
end

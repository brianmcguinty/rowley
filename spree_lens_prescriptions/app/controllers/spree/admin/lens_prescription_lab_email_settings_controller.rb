module Spree
  module Admin
    class LensPrescriptionLabEmailSettingsController < Spree::Admin::BaseController
      def show
        redirect_to(:action => :edit)
      end

      def update
        Spree::Config.set(params[:preferences])

        respond_to do |format|
          format.html {
            flash[:notice] = t(:lens_prescription_lab_email_settings_updated)
            redirect_to edit_admin_lens_prescription_lab_email_settings_path
          }
        end
      end

    end
  end
end


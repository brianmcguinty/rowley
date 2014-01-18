module Spree
  module Admin
    class LensPrescriptionUploadsSettingsController < Spree::Admin::BaseController
      
      def show
        redirect_to( :action => :edit )
      end

      def update
        Spree::Config.set(params[:preferences])
        update_paperclip_settings

        respond_to do |format|
          format.html {
            flash[:notice] = t(:lens_prescription_uploads_settings_updated)
            redirect_to edit_admin_lens_prescription_uploads_settings_path
          }
        end
      end


      private

      def update_paperclip_settings
        Spree::LensPrescription.attachment_definitions[:uploaded_copy][:path] = Spree::Config[:uploaded_copy_path]
        Spree::LensPrescription.attachment_definitions[:uploaded_copy][:default_url] = Spree::Config[:uploaded_copy_default_url]
        Spree::LensPrescription.attachment_definitions[:uploaded_copy][:url] = Spree::Config[:uploaded_copy_url]
      end
    end
  end
end

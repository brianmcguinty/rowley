module Spree
  module Admin
    class HeadTurnImagesController < ResourceController
      before_filter :load_data

      def show
        redirect_to(:action => :edit)
      end

      create.before :set_viewable
      update.before :set_viewable
      destroy.before :destroy_before

      private

        def location_after_save
          admin_product_head_turn_images_url(@product)
        end

        def load_data
          @product = Product.find_by_permalink(params[:product_id])
          @variants = @product.variants.collect do |variant|
            [variant.options_text, variant.id]
          end
          @variants.insert(0, [I18n.t(:all), @product.master.id])
        end

        def set_viewable
          @head_turn_image.viewable_type = 'Spree::Variant'
          @head_turn_image.viewable_id = params[:head_turn_image][:viewable_id]
        end

        def destroy_before
          @viewable = @head_turn_image.viewable
        end
    end
  end
end

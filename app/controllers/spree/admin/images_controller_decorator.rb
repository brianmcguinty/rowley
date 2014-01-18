Spree::Admin::ImagesController.class_eval do
  update.before :set_try_on_photo
  update.before :set_vto_image

  private
  def set_try_on_photo
    @image.try_on_photo = nil unless params[:image].key? :try_on_photo
  end

  def set_vto_image
      @image.vto_image = nil unless params[:image].key? :vto_image
    end

end
Spree::ProductsHelper.module_eval do

  def first_color(product)
    product.variants.first.option_value('frames-color') rescue 'n/a'
  end

  def try_on_photo(product)
    image_tag product.images.try_on_photo.first.attachment.url(:small), :id=>'product_try_on_photo' rescue ''
  end

  def head_turn_image(product)
    image = product.head_turn_images.first
    if image.present?
      render :partial => 'spree/shared/head_turn_image', :locals => {:image => image.attachment}
    else
      try_on_photo product
    end
  end

  def measurements(product)
    v = product.variants.first
    "#{v.width.to_i}-#{v.height.to_i}-#{v.depth.to_i}" rescue 'n/a'
  end

  def video(product)
    if product.video_id.present?
      "<iframe src='//player.vimeo.com/video/#{product.video_id}?title=0&byline=0' width='298' height='163' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>".html_safe
    end
  end

end
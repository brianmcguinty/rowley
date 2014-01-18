  Spree::Image.class_eval do
  attr_accessible :try_on_photo, :vto_image


  scope :try_on_photo,  -> { where(:try_on_photo => true) }
  scope :not_try_on_photo, -> { where(:try_on_photo => false) }

  scope :vto_image, -> {where(:vto_image => true)}
  scope :not_vto_image, -> {where(:vto_image => false)}

end
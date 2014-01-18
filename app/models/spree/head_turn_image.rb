module Spree
  class HeadTurnImage < Asset
    validates_attachment_presence :attachment
    validate :no_attachment_errors

    attr_accessible :alt, :attachment, :position, :viewable_type, :viewable_id

    has_attached_file :attachment,
                      :styles => { :mini => '643x60>', :full_size=>'1750x163' },
                      :default_style => :product,
                      :url => '/spree/products/:id/head_turn/:style/:basename.:extension',
                      :path => ':rails_root/public/spree/products/:id/head_turn/:style/:basename.:extension',
                      :convert_options => { :all => '-strip -auto-orient', :mini=>'-gravity center -crop "128x60+0+0"'}
    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    #after_post_process :find_dimensions

    include Spree::Core::S3Support
    supports_s3 :attachment

    def no_attachment_errors
      unless attachment.errors.empty?
        # uncomment this to get rid of the less-than-useful interrim messages
        # errors.clear
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end
  end
end

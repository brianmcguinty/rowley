Spree::Product.class_eval do

  delegate :head_turn_images, :to => :master, :prefix => true
  alias_method :head_turn_images, :master_head_turn_images

  delegate_belongs_to :master, :video_id

  has_many :variant_head_turn_images, :source => :head_turn_images, :through => :variants_including_master, :order => :position

  attr_accessible :featured, :sort_order, :is_new, :video_id, :ebay_item_id

  default_scope order('is_new DESC')

  add_search_scope :featured do
    where(:featured => true)
  end

  add_search_scope :is_new do
    where(:is_new => true)
  end

  add_search_scope :by_sku do |sku|
    variants_table = Spree::Variant.table_name
    joins(:master).where("#{variants_table}.sku LIKE ?", "%#{sku}%")
  end

  def is_optical?
    taxons.find_by_permalink('optical').present?
  end


end

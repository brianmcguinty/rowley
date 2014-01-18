Spree::Variant.class_eval do

  has_many :head_turn_images, :as => :viewable, :order => :position, :dependent => :destroy
  belongs_to :same_as_variant, :foreign_key => :same_as_variant_id, :class_name => 'Spree::Variant'
  has_many :child_variants, :foreign_key => :same_as_variant_id, :class_name => 'Spree::Variant'

  validate :same_as_variant_consistency

  scope :only_in_stock, -> {where('count_on_hand > 0')}
  scope :same_as_parent, -> { where('same_as_variant_id is null and is_master = 0') }

  attr_accessor :allocate_inventory_flag
  attr_writer :allocate_inventory_qty
  attr_accessible :sku_upc, :same_as_variant_id, :allocate_inventory_flag, :allocate_inventory_qty
  after_save :allocate_inventory

  def allocate_inventory_qty
    (@allocate_inventory_qty || linked_variants.sum(:count_on_hand)).to_i
  end

  def allocate_inventory
    if allocate_inventory_flag == '1'
      qty_per_variant = allocate_inventory_qty / linked_variants.count
      parent_variant_qty = qty_per_variant + allocate_inventory_qty % linked_variants.count
      parent_id = linked_variants_parent.id
      linked_variants.each do |v|
        v.on_hand = (parent_id == v.id ? parent_variant_qty : qty_per_variant)
        v.save
      end
    end
  end

  #### HTO ####
  def on_demand=(on_demand)
    self[:on_demand] = on_demand
    if self.on_demand
      inventory_units.with_state('backordered').each(&:fill_backorder)
    end
  end
  #############
  #

  def linked_variants
    self.class.where('same_as_variant_id = :id or id = :id', :id => same_as_variant.try(:id) || id)
  end

  def linked_variants_parent
    same_as_variant || if child_variants.any? then self end
  end

  def same_as_variant_consistency
    if same_as_variant.present? && same_as_variant.same_as_variant.present?
      errors.add(:same_as_variant_id, 'Invalid main variant')
    end
    if same_as_variant.present? && child_variants.any?
      errors.add(:same_as_variant_id, 'Invalid main variant')
    end
  end

  def sku_with_linked
    child_sku = child_variants.map(&:sku)
    "#{sku}#{if child_sku.present? then " (+ #{child_sku.join(', ')})" end}"
  end
end

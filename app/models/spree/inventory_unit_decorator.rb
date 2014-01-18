Spree::InventoryUnit.class_eval do
  def self.increase(order, variant, quantity)
    back_order = determine_backorder(order, variant, quantity)
    sold = quantity - back_order

    #set on_hand if configured
    if self.track_levels?(variant)
      variant.decrement!(:count_on_hand, quantity)
    end

    #create units if configured
    if Spree::Config[:create_inventory_units]
      create_units(order, variant, sold, back_order)
    end
  end

  def self.decrease(order, variant, quantity)
    if self.track_levels?(variant)
      variant.increment!(:count_on_hand, quantity)
    end

    if Spree::Config[:create_inventory_units]
      destroy_units(order, variant, quantity)
    end
  end

  def self.determine_backorder(order, variant, quantity)
    variant_on_hand = variant.on_hand
    if variant_on_hand == 0
      quantity
    elsif variant_on_hand.present? and variant_on_hand < quantity
      quantity - (variant_on_hand < 0 ? 0 : variant_on_hand)
    else
      0
    end
  end

  def restock_variant
    if self.class.track_levels?(variant)
      variant.on_hand += 1
      variant.save
    end
  end
end

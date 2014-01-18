Spree::OrderPopulator.class_eval do
  def check_stock_levels(variant, quantity)
    display_name = %Q{#{variant.name}}
      display_name += %Q{ (#{variant.options_text})} unless variant.options_text.blank?

      if variant.available?
        on_hand = variant.on_hand
        if on_hand >= quantity || Spree::Config[:allow_backorders]
          return true
        else
          errors.add(:base, %Q{There are only #{on_hand} of #{display_name.inspect} remaining.} + 
                     %Q{ Please select a quantity less than or equal to this value.})
          return false
        end
      else
        errors.add(:base, %Q{#{display_name.inspect} is out of stock.})
          return false
      end
  end
end

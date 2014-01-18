module Spree
  class HtoOrderPopulator
    attr_accessor :order, :currency
    attr_reader :errors

    def initialize(order, currency)
      @order = order
      @currency = currency
      @errors = ActiveModel::Errors.new(self)
    end

    #
    # Parameters can be passed using the following possible parameter configurations:
    #
    # +:variants => { variant_id => ? }+
    #
    # * Multiple products at once
    # +:products => { product_id => variant_id, product_id => variant_id }
    def populate(from_hash)
      from_hash[:products].each do |product_id, variant_id|
        attempt_cart_add(variant_id)
      end if from_hash[:products]

      from_hash[:variants].each do |variant_id, quantity|
        attempt_cart_add(variant_id)
      end if from_hash[:variants]

      valid?
    end

    def valid?
      errors.empty?
    end

    private

    def attempt_cart_add(variant_id)
      unless @order.hto_sufficient_items?
        unless @order.line_items.where(:variant_id => variant_id).where('spree_line_items.quantity > 0').any?
          variant = Spree::Variant.find(variant_id)
          if check_stock_levels(variant)
            @order.add_variant(variant, 1, currency)
          end
        end
      end
    end

    def check_stock_levels(variant)
      display_name = %Q{#{variant.name}}
      display_name += %Q{ (#{variant.options_text})} unless variant.options_text.blank?

      if variant.available?
        hto_on_hand = variant.on_hand
        if hto_on_hand >= 1 || Spree::Config[:allow_backorders]
          return true
        else
          errors.add(:base, %Q{There are only #{hto_on_hand} of #{display_name.inspect} remaining.} + 
                            %Q{ Please select a quantity less than or equal to this value.})
          return false
        end
      else
        errors.add(:base, %Q{#{display_name.inspect} is out of stock.})
        return false
      end
    end
  end
end

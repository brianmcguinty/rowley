module Spree
  Variant.class_eval do
    attr_accessible :sale_price

    alias_method :orig_price_in, :price_in

    def price_in(currency)
      return orig_price_in(currency) unless has_sale_price?
      Spree::Price.new(:variant_id => self.id, :amount => self.sale_price, :currency => currency)
    end

    def has_sale_price?
      sale_price.present? && sale_price > 0 && sale_price < price
    end

    def self.clear_sale_prices
      update_all sale_price: nil
    end

  end
end
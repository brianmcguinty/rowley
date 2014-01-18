module Spree
  LineItem.class_eval do
    def display_price
      Spree::Money.new(price, { :currency => currency })
    end
  end
end

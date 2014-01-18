require_dependency 'spree/calculator'

module Spree
  class Calculator::OneFreeFrame < Calculator
    def self.description
      I18n.t(:one_free_frame)
    end

    def compute(object)
      order = object
      return unless order.present? and order.line_items.present? and order.item_count > 0
      cheapest_line_item = order.line_items.min_by(&:price)
      (cheapest_line_item.price + 
       order.lens_total / order.item_count + 
       order.subscription_discount_total / order.item_count).round(2)
    end
  end
end

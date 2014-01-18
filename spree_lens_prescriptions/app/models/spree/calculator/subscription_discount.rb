module Spree
  class Calculator::SubscriptionDiscount < Calculator
    def compute(object = nil)
      case object
      when Spree::OrderSubscriptionDiscount
        @order = object.order
        @order_subscription_discount = object
      when Spree::Order
        @order = object
        @order_subscription_discount = object.order_subscription_discount
      end
      @lens_meta_prescription = @order.lens_meta_prescription
      if @order && @lens_meta_prescription 
        @lens_prescription = @lens_meta_prescription.lens_prescription
        -(@order.item_total + @order.lens_total) * @order_subscription_discount.discount_percent.to_f / 100.0 rescue 0.0
      else
        0.0
      end
    end
  end
end

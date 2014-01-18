# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class Promotion
    module Rules
      class ItemAndLensTotal < PromotionRule
        preference :amount, :decimal, :default => 100.00
        preference :operator, :string, :default => '>'

        attr_accessible :preferred_amount, :preferred_operator

        OPERATORS = ['gt', 'gte']

        def eligible?(order, options = {})
          item_total = order.line_items.map(&:amount).sum
          lens_addition = if order.lens_meta_prescription then order.lens_meta_prescription.calculator.compute(order) else 0.0 end
          (item_total.to_f + lens_addition.to_f).send(preferred_operator == 'gte' ? :>= : :>, BigDecimal.new(preferred_amount.to_s))
        end
      end
    end
  end
end

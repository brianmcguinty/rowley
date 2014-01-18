Spree::Promotion::Actions::CreateAdjustment.class_eval do
  def compute_amount(calculable)
    [(calculable.item_total + calculable.ship_total + calculable.lens_total + calculable.subscription_discount_total), super.to_f.abs].min * -1
  end
end

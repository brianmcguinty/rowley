Spree::Promotion.class_eval do
  def orders
    Spree::Order.find_by_sql(["select o.*
                             from spree_promotion_actions pa
                             join spree_adjustments ad on ad.originator_id = pa.id and ad.originator_type='Spree::PromotionAction'
                             join spree_orders o on o.id = ad.adjustable_id
                             where pa.activator_id = ?", id])
  end
end

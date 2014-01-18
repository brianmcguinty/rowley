# This migration comes from spree_lens_prescriptions (originally 20130508130939)
class AddDiscountPercentToOrderSubscriptionDiscounts < ActiveRecord::Migration
  def change
    add_column :spree_order_subscription_discounts, :discount_percent, :decimal, :precision => 10, :scale => 2
  end
end

# This migration comes from spree_lens_prescriptions (originally 20130508081812)
class CreateSpreeOrderSubscriptionDiscounts < ActiveRecord::Migration
  def change
    create_table :spree_order_subscription_discounts do |t|
      t.integer :order_id
      t.integer :subscription_id

      t.timestamps
    end
    add_index :spree_order_subscription_discounts, :order_id
    add_index :spree_order_subscription_discounts, :subscription_id
  end
end

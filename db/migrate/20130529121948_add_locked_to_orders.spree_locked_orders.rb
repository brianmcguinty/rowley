# This migration comes from spree_locked_orders (originally 20130529120901)
class AddLockedToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :locked_at, :datetime
    add_column :spree_orders, :locked_by, :integer
    add_index :spree_orders, :locked_at
    add_index :spree_orders, :locked_by
  end
end

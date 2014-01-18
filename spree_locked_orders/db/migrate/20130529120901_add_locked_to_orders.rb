class AddLockedToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :locked_at, :datetime
    add_column :spree_orders, :locked_by, :integer
    add_index :spree_orders, :locked_at
    add_index :spree_orders, :locked_by
  end
end

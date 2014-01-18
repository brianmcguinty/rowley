# This migration comes from spree_hto (originally 20130705083723)
class AddHtoToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :hto, :boolean, :default => false
    add_index :spree_orders, :hto
  end
end

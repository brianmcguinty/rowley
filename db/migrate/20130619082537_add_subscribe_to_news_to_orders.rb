class AddSubscribeToNewsToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :subscribe_to_news, :boolean, :default => true
  end
end

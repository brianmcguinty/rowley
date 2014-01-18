class AddIsNewPropertyToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_new, :boolean, :default => false
  end
end

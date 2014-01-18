# This migration comes from spree_home_page (originally 20130403204703)
class AddFeaturedPropertyToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :featured, :boolean, :default => false
    add_column :spree_products, :sort_order, :integer
  end
end

class AddEbayItemIdToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :ebay_item_id, :string
  end
end

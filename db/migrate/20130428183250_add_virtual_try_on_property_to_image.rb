class AddVirtualTryOnPropertyToImage < ActiveRecord::Migration
  def change
    add_column :spree_assets, :vto_image, :boolean, :default => false
  end
end

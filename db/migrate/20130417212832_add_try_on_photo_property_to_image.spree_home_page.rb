# This migration comes from spree_home_page (originally 20130417202532)
class AddTryOnPhotoPropertyToImage < ActiveRecord::Migration
  def change
    add_column :spree_assets, :try_on_photo, :boolean, :default => false
  end
end

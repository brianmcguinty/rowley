# This migration comes from spree_lens_prescriptions (originally 20130501101429)
class AddOrderIdToLensMetaPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_meta_prescriptions, :order_id, :integer
    add_index :spree_lens_meta_prescriptions, :order_id
  end
end

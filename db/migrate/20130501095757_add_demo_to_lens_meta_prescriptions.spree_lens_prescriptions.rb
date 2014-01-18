# This migration comes from spree_lens_prescriptions (originally 20130501095651)
class AddDemoToLensMetaPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_meta_prescriptions, :demo, :boolean, :default => true
  end
end

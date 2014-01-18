# This migration comes from spree_lens_prescriptions (originally 20130422210654)
class AddDemoToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :demo, :boolean, :default => true
  end
end

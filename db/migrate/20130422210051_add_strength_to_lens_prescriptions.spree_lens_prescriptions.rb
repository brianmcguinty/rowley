# This migration comes from spree_lens_prescriptions (originally 20130422205722)
class AddStrengthToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :strength, :decimal, :precision => 10, :scale => 2
  end
end

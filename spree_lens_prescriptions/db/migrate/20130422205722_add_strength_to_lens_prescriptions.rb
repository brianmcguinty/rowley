class AddStrengthToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :strength, :decimal, :precision => 10, :scale => 2
  end
end

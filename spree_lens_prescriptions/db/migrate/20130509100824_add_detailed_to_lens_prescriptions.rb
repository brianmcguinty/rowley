class AddDetailedToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :detailed, :boolean, :default => false
    add_index :spree_lens_prescriptions, :detailed
  end
end

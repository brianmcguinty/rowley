class AddCharacteristicsToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :glasses_type, :string
    add_column :spree_lens_prescriptions, :type, :string
    add_column :spree_lens_prescriptions, :wear, :string
    add_column :spree_lens_prescriptions, :tint, :string
  end
end

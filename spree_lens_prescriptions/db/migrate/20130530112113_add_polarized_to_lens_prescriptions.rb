class AddPolarizedToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :polarized, :string
    add_column :spree_lens_meta_prescriptions, :polarized, :string
  end
end

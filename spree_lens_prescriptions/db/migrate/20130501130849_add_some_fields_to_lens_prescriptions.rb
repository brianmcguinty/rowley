class AddSomeFieldsToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :state_id, :integer
    add_column :spree_lens_prescriptions, :verification_method, :string
    add_index :spree_lens_prescriptions, :state_id
  end
end

# This migration comes from spree_lens_prescriptions (originally 20130501130849)
class AddSomeFieldsToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :state_id, :integer
    add_column :spree_lens_prescriptions, :verification_method, :string
    add_index :spree_lens_prescriptions, :state_id
  end
end

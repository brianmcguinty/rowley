# This migration comes from spree_lens_prescriptions (originally 20130501161924)
class MoveFieldsFromLensPrescriptionsToLensMetaPrescriptions < ActiveRecord::Migration
  def up
    add_column :spree_lens_meta_prescriptions, :wear, :string
    add_column :spree_lens_meta_prescriptions, :transition, :boolean
    add_column :spree_lens_meta_prescriptions, :state_id, :integer
    add_column :spree_lens_meta_prescriptions, :verification_method, :string
    add_column :spree_lens_meta_prescriptions, :lens_type, :string
    add_index :spree_lens_meta_prescriptions, :state_id

    remove_column :spree_lens_prescriptions, :tint
    remove_column :spree_lens_prescriptions, :transition
    remove_column :spree_lens_prescriptions, :state_id
    remove_column :spree_lens_prescriptions, :verification_method
    remove_column :spree_lens_prescriptions, :lens_type
  end
end

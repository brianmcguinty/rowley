# This migration comes from spree_lens_prescriptions (originally 20130616082902)
class MoveStatusToMetaPrescription < ActiveRecord::Migration
  def up
    add_column :spree_lens_meta_prescriptions, :state, :string
    add_index :spree_lens_meta_prescriptions, :state
    execute 'update spree_lens_prescriptions lp, spree_lens_meta_prescriptions lmp set lmp.state = lp.status where lp.prescription_container_type = "Spree::LensMetaPrescription" and lp.prescription_container_id = lmp.id'
    remove_column :spree_lens_prescriptions, :status
  end
end

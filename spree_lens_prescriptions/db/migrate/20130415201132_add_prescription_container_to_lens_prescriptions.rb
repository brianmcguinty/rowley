class AddPrescriptionContainerToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :prescription_container_id, :integer
    add_column :spree_lens_prescriptions, :prescription_container_type, :string
    add_index :spree_lens_prescriptions, :prescription_container_id
  end
end

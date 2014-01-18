class AddDoctorFieldsToLensMetaPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_meta_prescriptions, :doctor_name, :string
    add_column :spree_lens_meta_prescriptions, :doctor_phone, :string
    add_column :spree_lens_meta_prescriptions, :patient_name, :string
    add_column :spree_lens_meta_prescriptions, :patient_birth_date, :date
  end
end

# This migration comes from spree_lens_prescriptions (originally 20130501170008)
class RestoreFieldsInLensPrescriptions < ActiveRecord::Migration
  def up
    add_column :spree_lens_prescriptions, :tint, :string
    add_column :spree_lens_prescriptions, :transition, :boolean
    add_column :spree_lens_prescriptions, :state_id, :integer
    add_column :spree_lens_prescriptions, :verification_method, :string
    add_column :spree_lens_prescriptions, :lens_type, :string
    add_column :spree_lens_prescriptions, :doctor_name, :string
    add_column :spree_lens_prescriptions, :doctor_phone, :string
    add_column :spree_lens_prescriptions, :patient_name, :string
    add_column :spree_lens_prescriptions, :patient_birth_date, :date
    add_column :spree_lens_prescriptions, :name, :string

    remove_column :spree_lens_meta_prescriptions, :wear
    remove_column :spree_lens_meta_prescriptions, :transition
    remove_column :spree_lens_meta_prescriptions, :state_id
    remove_column :spree_lens_meta_prescriptions, :verification_method
    remove_column :spree_lens_meta_prescriptions, :lens_type
    remove_column :spree_lens_meta_prescriptions, :doctor_name
    remove_column :spree_lens_meta_prescriptions, :doctor_phone
    remove_column :spree_lens_meta_prescriptions, :patient_name
    remove_column :spree_lens_meta_prescriptions, :patient_birth_date
  end
end

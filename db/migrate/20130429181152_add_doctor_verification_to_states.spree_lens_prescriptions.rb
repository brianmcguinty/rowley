# This migration comes from spree_lens_prescriptions (originally 20130429181012)
class AddDoctorVerificationToStates < ActiveRecord::Migration
  def change
    add_column :spree_states, :doctor_verification, :boolean, :default => false
  end
end

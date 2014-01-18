class AddDoctorVerificationToStates < ActiveRecord::Migration
  def change
    add_column :spree_states, :doctor_verification, :boolean, :default => false
  end
end

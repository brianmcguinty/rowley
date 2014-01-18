class AddTransitionToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :transition, :boolean, :default => false
  end
end

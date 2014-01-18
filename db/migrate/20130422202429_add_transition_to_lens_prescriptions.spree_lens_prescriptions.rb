# This migration comes from spree_lens_prescriptions (originally 20130422202241)
class AddTransitionToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :transition, :boolean, :default => false
  end
end

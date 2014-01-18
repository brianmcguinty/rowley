# This migration comes from spree_lens_prescriptions (originally 20130421212553)
class AddTwoPdsToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :two_pds, :boolean, :default => false
  end
end

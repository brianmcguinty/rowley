class AddTwoPdsToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :two_pds, :boolean, :default => false
  end
end

# This migration comes from spree_lens_prescriptions (originally 20130611091859)
class AddStatusToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :status, :string, :default => :verify
    add_index :spree_lens_prescriptions, :status
  end
end

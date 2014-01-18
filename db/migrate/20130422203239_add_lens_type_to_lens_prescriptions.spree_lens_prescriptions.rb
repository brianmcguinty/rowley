# This migration comes from spree_lens_prescriptions (originally 20130422203215)
class AddLensTypeToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :lens_type, :string
  end
end

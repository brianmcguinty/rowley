class AddLensTypeToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :lens_type, :string
  end
end

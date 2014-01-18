class ChangeSomeFieldsInLensPrescriptions < ActiveRecord::Migration
  def up
    remove_column :spree_lens_prescriptions, :glasses_type
    remove_column :spree_lens_prescriptions, :strength
    remove_column :spree_lens_prescriptions, :demo
  end
end

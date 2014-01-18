# This migration comes from spree_lens_prescriptions (originally 20130501094902)
class ChangeSomeFieldsInLensPrescriptions < ActiveRecord::Migration
  def up
    remove_column :spree_lens_prescriptions, :glasses_type
    remove_column :spree_lens_prescriptions, :strength
    remove_column :spree_lens_prescriptions, :demo
  end
end

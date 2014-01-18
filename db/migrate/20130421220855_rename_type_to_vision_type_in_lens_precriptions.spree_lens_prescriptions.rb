# This migration comes from spree_lens_prescriptions (originally 20130421220815)
class RenameTypeToVisionTypeInLensPrecriptions < ActiveRecord::Migration
  def up
    rename_column :spree_lens_prescriptions, :type, :vision_type
  end
end

class RenameTypeToVisionTypeInLensPrecriptions < ActiveRecord::Migration
  def up
    rename_column :spree_lens_prescriptions, :type, :vision_type
  end
end

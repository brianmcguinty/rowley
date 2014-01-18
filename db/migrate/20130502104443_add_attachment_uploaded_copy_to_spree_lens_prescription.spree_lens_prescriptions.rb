# This migration comes from spree_lens_prescriptions (originally 20130502103943)
class AddAttachmentUploadedCopyToSpreeLensPrescription < ActiveRecord::Migration
  def self.up
    add_column :spree_lens_prescriptions, :uploaded_copy_file_name, :string
    add_column :spree_lens_prescriptions, :uploaded_copy_content_type, :string
    add_column :spree_lens_prescriptions, :uploaded_copy_file_size, :integer
    add_column :spree_lens_prescriptions, :uploaded_copy_updated_at, :datetime
  end

  def self.down
    remove_column :spree_lens_prescriptions, :uploaded_copy_file_name
    remove_column :spree_lens_prescriptions, :uploaded_copy_content_type
    remove_column :spree_lens_prescriptions, :uploaded_copy_file_size
    remove_column :spree_lens_prescriptions, :uploaded_copy_updated_at
  end
end

class AddDemoToLensMetaPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_meta_prescriptions, :demo, :boolean, :default => true
  end
end

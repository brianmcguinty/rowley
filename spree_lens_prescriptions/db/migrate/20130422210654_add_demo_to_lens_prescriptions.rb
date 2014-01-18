class AddDemoToLensPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_prescriptions, :demo, :boolean, :default => true
  end
end

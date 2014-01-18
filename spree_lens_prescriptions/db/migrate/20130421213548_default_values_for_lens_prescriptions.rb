class DefaultValuesForLensPrescriptions < ActiveRecord::Migration
  def up
    change_column :spree_lens_prescriptions, :left_sph, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :left_cyl, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :left_axis, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :left_add, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :left_pd, :decimal, :precision => 10, :scale => 2, :default => 30.0
    change_column :spree_lens_prescriptions, :right_sph, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :right_cyl, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :right_axis, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :right_add, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :spree_lens_prescriptions, :right_pd, :decimal, :precision => 10, :scale => 2, :default => 30.0
    change_column :spree_lens_prescriptions, :pd, :decimal, :precision => 10, :scale => 2, :default => 60.0
  end
end

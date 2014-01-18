# This migration comes from spree_lens_prescriptions (originally 20130402205132)
class CreateSpreeLensPrescriptions < ActiveRecord::Migration
  def change
    create_table :spree_lens_prescriptions do |t|
      t.decimal :left_sph, :precision => 10, :scale => 2
      t.decimal :left_cyl, :precision => 10, :scale => 2
      t.decimal :left_axis, :precision => 10, :scale => 2
      t.decimal :left_add, :precision => 10, :scale => 2
      t.decimal :left_pd, :precision => 10, :scale => 2
      t.decimal :right_sph, :precision => 10, :scale => 2
      t.decimal :right_cyl, :precision => 10, :scale => 2
      t.decimal :right_axis, :precision => 10, :scale => 2
      t.decimal :right_add, :precision => 10, :scale => 2
      t.decimal :right_pd, :precision => 10, :scale => 2
      t.decimal :pd, :precision => 10, :scale => 2

      t.timestamps
    end
  end
end

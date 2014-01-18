# This migration comes from spree_lens_prescriptions (originally 20130429193713)
class CreateSpreeLensMetaPrescriptions < ActiveRecord::Migration
  def change
    create_table :spree_lens_meta_prescriptions do |t|
      t.string :glasses_type
      t.string :prescription_input_method
      t.string :tint
      t.decimal :strength, :precision => 10, :scale => 2
      t.integer :user_lens_prescription_id

      t.timestamps
    end
    add_index :spree_lens_meta_prescriptions, :user_lens_prescription_id
  end
end

# This migration comes from spree_lens_prescriptions (originally 20130507131930)
class CreateSpreeSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_subscriptions do |t|
      t.integer :user_id
      t.string :period
      t.date :next_billing_date
      t.date :end_date
      t.string :status, :default => :active

      t.timestamps
    end
    add_index :spree_subscriptions, :user_id

  end
end

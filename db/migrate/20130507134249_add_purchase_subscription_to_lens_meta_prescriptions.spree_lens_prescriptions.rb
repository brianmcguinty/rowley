# This migration comes from spree_lens_prescriptions (originally 20130507133945)
class AddPurchaseSubscriptionToLensMetaPrescriptions < ActiveRecord::Migration
  def change
    add_column :spree_lens_meta_prescriptions, :purchase_subscription, :string
    add_column :spree_lens_meta_prescriptions, :subscription_id, :integer
    add_index :spree_lens_meta_prescriptions, :subscription_id
  end
end

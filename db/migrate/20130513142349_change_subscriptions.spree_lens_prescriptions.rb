# This migration comes from spree_lens_prescriptions (originally 20130513141859)
class ChangeSubscriptions < ActiveRecord::Migration
  def up
    add_column :spree_subscriptions, :subscription_id, :string
    remove_column :spree_subscriptions, :next_billing_date
    remove_column :spree_subscriptions, :end_date
  end
end

# This migration comes from spree_lens_prescriptions (originally 20130513142510)
class ChangeSubscriptions2 < ActiveRecord::Migration
  def change
    rename_column :spree_subscriptions, :subscription_id, :arb_subscription_id
  end
end

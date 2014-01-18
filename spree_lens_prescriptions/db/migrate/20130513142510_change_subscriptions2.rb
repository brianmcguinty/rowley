class ChangeSubscriptions2 < ActiveRecord::Migration
  def change
    rename_column :spree_subscriptions, :subscription_id, :arb_subscription_id
  end
end

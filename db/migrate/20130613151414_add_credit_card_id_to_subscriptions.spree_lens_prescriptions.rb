# This migration comes from spree_lens_prescriptions (originally 20130613150801)
class AddCreditCardIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :credit_card_id, :integer
    add_index :spree_subscriptions, :credit_card_id
  end
end

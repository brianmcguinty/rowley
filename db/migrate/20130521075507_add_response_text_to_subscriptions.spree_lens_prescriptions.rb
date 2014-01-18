# This migration comes from spree_lens_prescriptions (originally 20130521074816)
class AddResponseTextToSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :response_text, :text
  end
end

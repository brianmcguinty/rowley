class AddResponseTextToSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :response_text, :text
  end
end

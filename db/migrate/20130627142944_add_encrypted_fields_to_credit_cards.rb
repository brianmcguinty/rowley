class AddEncryptedFieldsToCreditCards < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :encrypted_stored_number, :string
    add_column :spree_credit_cards, :encrypted_stored_verification_value, :string
  end
end

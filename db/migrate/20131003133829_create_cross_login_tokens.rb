class CreateCrossLoginTokens < ActiveRecord::Migration
  def change
    create_table :spree_cross_login_tokens do |t|
      t.string :value
      t.references :user
      t.datetime :expire_at

      t.timestamps
    end
    add_index :spree_cross_login_tokens, :value
    add_index :spree_cross_login_tokens, :user_id
  end
end

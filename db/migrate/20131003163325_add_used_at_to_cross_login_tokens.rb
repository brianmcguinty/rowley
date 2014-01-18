class AddUsedAtToCrossLoginTokens < ActiveRecord::Migration
  def change
    add_column :spree_cross_login_tokens, :used_at, :datetime
  end
end

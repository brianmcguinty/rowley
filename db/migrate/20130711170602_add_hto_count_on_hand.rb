class AddHtoCountOnHand < ActiveRecord::Migration
  def change
    add_column :spree_variants, :hto_count_on_hand, :integer, :default => 0
    add_column :spree_products, :hto_count_on_hand, :integer, :default => 0
  end
end

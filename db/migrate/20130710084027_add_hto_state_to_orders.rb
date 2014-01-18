class AddHtoStateToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :hto_state, :string
  end
end

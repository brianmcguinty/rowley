class AddHtoDisableAutoCaptureToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :hto_disabled_auto_capture, :boolean, :default => false
  end
end

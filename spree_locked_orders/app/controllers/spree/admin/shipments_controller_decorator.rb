Spree::Admin::ShipmentsController.class_eval do
  ensure_order_lock :except => [:index, :show]
end

Spree::Admin::Orders::CustomerDetailsController.class_eval do
  ensure_order_lock
end

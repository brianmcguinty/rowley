Spree::Admin::PaymentsController.class_eval do
  ensure_order_lock :except => [:index, :show]
end

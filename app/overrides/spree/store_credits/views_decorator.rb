Deface::Override.new(
  :virtual_path => "spree/checkout/_billing",
  :name => "store_credits_checkout_billing_step",
  :insert_after => "[data-hook='checkout_payment_step']",
  :partial => "spree/checkout/store_credits",
  :disabled => true)

Deface::Override.new(
  :virtual_path => "spree/users/show",
  :name => "store_credits_account_my_orders",
  :insert_before => "[data-hook='account_my_orders']",
  :partial => "spree/users/store_credits",
  :disabled => true)
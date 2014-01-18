Spree::AppConfiguration.class_eval do
  #hto
  preference :hto_delivered_days, :decimal, :default => 5
  preference :hto_warning_days, :decimal, :default => 10
  preference :hto_overdue_days, :decimal, :default => 12
  preference :hto_auto_capture_days, :decimal, :default => 17
  preference :hto_items, :decimal, :default => 4
  preference :hto_capture_manually_email, :string, :default => 'info@brobinson.com'
end

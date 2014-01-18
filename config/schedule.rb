set :output, "#{path}/log/cron.log"
every '0 1 15 * *' do
  runner 'Spree::Subscription.notify_subscribers_about_expiration'
end

every '0 1 3 * *' do
  runner 'Spree::Subscription.update_statuses'
end

# every '0 1 * * *' do
#   runner 'Spree::Order.notify_about_incomplete_prescriptions(Date.today - 1.day)'
# end

every '0 * * * *' do
  runner 'Spree::Order.notify_about_verify_or_pending_prescriptions'
end

every '0 2 * * *' do
  runner 'Spree::Order.update_hto_states'
end

every '0 3 * * *' do
  runner 'Spree::Order.hto_auto_capture_overdues'
end

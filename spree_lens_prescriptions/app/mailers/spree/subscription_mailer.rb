class Spree::SubscriptionMailer < ActionMailer::Base
  helper 'spree/base'

  def confirm_email(subscription)
    @subscription = subscription
    subject = "#{Spree::Config[:site_name]} #{t('subscription_mailer.confirmation_email.subject')}"
    mail(:to => subscription.user.email, :subject => subject)
  end

  def expiration_email(subscription)
    @subscription = subscription
    subject = ''
    subject += "#{Spree::Config[:site_name]} #{t('subscription_mailer.expiration_email.subject')}"
    mail(:to => subscription.user.email, :subject => subject)
  end

  def cancel_email(subscription)
    @subscription = subscription
    subject = ''
    subject += "#{Spree::Config[:site_name]} #{t('subscription_mailer.cancel_email.subject')}"
    mail(:to => subscription.user.email, :subject => subject)
  end
end

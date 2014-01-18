class Spree::HtoMailer < ActionMailer::Base
  helper 'spree/base'

  def delivered_email(order)
    @order = order
    subject = "#{Spree::Config[:site_name]} #{t('hto_mailer.delivered_email.subject')} ##{order.number}"
    mail(:to => order.email, :subject => subject)
  end

  def warning_email(order)
    @order = order
    subject = "#{Spree::Config[:site_name]} #{t('hto_mailer.warning_email.subject')} ##{order.number}"
    mail(:to => order.email, :subject => subject)
  end

  def overdue_email(order)
    @order = order
    subject = "#{Spree::Config[:site_name]} #{t('hto_mailer.overdue_email.subject')} ##{order.number}"
    mail(:to => order.email, :subject => subject)
  end

  def returned_email(order)
    @order = order
    subject = "#{Spree::Config[:site_name]} #{t('hto_mailer.returned_email.subject')} ##{order.number}"
    mail(:to => order.email, :subject => subject)
  end

  def paid_email(order)
    @order = order
    subject = "#{Spree::Config[:site_name]} #{t('hto_mailer.paid_email.subject')} ##{order.number}"
    mail(:to => order.email, :subject => subject)
  end

  def capture_manually_email(orders)
    @orders = orders
    subject = "#{Spree::Config[:site_name]} #{t('hto_mailer.capture_manually_email.subject')}"
    mail(:to => Spree::Config.hto_capture_manually_email, :subject => subject)
  end
end

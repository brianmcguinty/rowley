Spree::TestMailer.class_eval do

  def test2_email(email_to)
    subject = "#{Spree::Config[:site_name]} #{t('test_mailer.test_email.subject')}"

    mail(:to => email_to,
         :subject => subject,
         :body => 'Test Email'
    )
  end
end

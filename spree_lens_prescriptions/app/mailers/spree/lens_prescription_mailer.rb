class Spree::LensPrescriptionMailer < ActionMailer::Base
  helper 'spree/base'
  def details_required_list_email(for_date)
    @orders = Spree::Order.complete.joins(:lens_meta_prescription => :lens_prescription).
      where('spree_lens_prescriptions.detailed = 0').where('date(completed_at) = ?', for_date)
    subject = ''
    subject += "#{Spree::Config[:site_name]} #{t('lens_prescription_mailer.details_required_list_email.subject')} #{for_date.strftime('%m/%d/%Y')}"
    mail(:to => Spree::Config.prescription_details_required_email, :subject => subject)
  end

  def verify_or_pending_list_email
    @orders = Spree::Order.complete.not_canceled.contains_verify_or_pending_prescription
    subject = ''
    subject += "#{Spree::Config[:site_name]} #{t('lens_prescription_mailer.verify_or_pending_list_email.subject')}"
    mail(:to => Spree::Config.prescription_details_required_email, :subject => subject)
  end

  def prescription_to_lab(meta_prescription)
    @order = meta_prescription.order
    subject = "#{Spree::Config[:lp_customer_num]}-#{Spree::Config[:lp_lab_num]}-#{@order.number}"
    file_to_render = 'spree/admin/orders/show.rx.erb'
    if @order.lens_meta_prescription.glasses_type == 'frames_sunglasses' && @order.lens_meta_prescription.demo?
      file_to_render = 'spree/admin/orders/demo_lenses.rx.erb'
    end
    attachments["#{subject}.rx"] = render_to_string(:file => file_to_render)
    mail(:to => Spree::Config[:lp_lab_email],
         :return_path => Spree::Config[:lp_lab_email_from],
         :subject => subject,
         :body =>'')
  end

end

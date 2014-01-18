Spree::PaymentMethod.class_eval do
  def auto_capture?
    true
  end
end

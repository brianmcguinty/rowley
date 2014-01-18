Spree::Payment.class_eval do
  def process!
    if payment_method && payment_method.source_required?
      if source
        if !processing?
          if order.hto?
            authorize!
          else
            purchase!
          end
        end
      else
        raise Core::GatewayError.new(I18n.t(:payment_processing_failed))
      end
    end
  end
end

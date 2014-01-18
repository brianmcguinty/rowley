Spree::Adjustment.class_eval do
  def update!(src = nil)
    src ||= source
    return if locked? && !(adjustable_type == 'Spree::Order' && Spree::Order.ignore_adjustments_lock)
    if originator.present?
      originator.update_adjustment(self, src)
    end
    set_eligibility
  end
end


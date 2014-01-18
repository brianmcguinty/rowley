require_dependency 'spree/calculator'

module Spree
  class Calculator::FlatPercentItemAndLensTotal < Calculator
    preference :flat_percent, :decimal, :default => 0
    attr_accessible :preferred_flat_percent

    def self.description
      I18n.t(:flat_percent_plus_lens)
    end

    def compute(object)
      return unless object.present? and object.line_items.present?
      item_total = object.line_items.map(&:amount).sum
      value = item_total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
      # lens prescription addition
      if object.lens_meta_prescription.present?
        value += object.lens_total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0 rescue 0.0
      end
      #
      (value * 100).round.to_f / 100
    end
  end
end

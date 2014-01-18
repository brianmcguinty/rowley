module Spree
  Order.class_eval do
    has_one :lens_meta_prescription
    has_one :order_subscription_discount
    attr_accessible :lens_meta_prescription, :lens_meta_prescription_attributes
    accepts_nested_attributes_for :lens_meta_prescription

    def display_subtotal
      Spree::Money.new(item_total + lens_meta_prescription.adjustment2.amount, { :currency => currency })
    end

    def display_lenses_total
      Spree::Money.new(lens_meta_prescription.adjustment2.amount, { :currency => currency })
    end

    def auto_verify_prescription
      if lens_meta_prescription.prescription_based?
        lens_meta_prescription.lens_prescription.auto_verify
      end
    end

    def send_prescription_to_lab
      if !lens_meta_prescription.prescription_based? || lens_meta_prescription.lens_prescription.detailed?
        lens_meta_prescription.send_to_lab
      end
    end

    def lens_adjustment
      adjustments.where(:source_type => 'Spree::LensMetaPrescription').first
    end

    # def lens_total
    #   if la = lens_adjustment then la.amount else 0.0 end
    # end

    def lens_total(disable_calculation = false)
      if la = lens_adjustment 
        if disable_calculation || la.locked?
          la.amount 
        else 
          la.originator.calculator.compute(la.adjustable)
        end
      else 
        0.0 
      end
    end

    def subscription_discount_adjustment
      adjustments.where(:source_type => 'Spree::OrderSubscriptionDiscount').first
    end

    def subscription_discount_total
      if sda = subscription_discount_adjustment
        if sda.locked?
          sda.amount 
        else 
          sda.originator.calculator.compute(sda.adjustable)
        end
      else 
        0.0 
      end
    end

    def self.contains_verify_or_pending_prescription
      joins(:lens_meta_prescription).where('spree_lens_meta_prescriptions.state in ("pending", "verify")')
    end
  end
end

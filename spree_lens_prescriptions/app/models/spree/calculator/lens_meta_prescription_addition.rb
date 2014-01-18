module Spree
  class Calculator::LensMetaPrescriptionAddition < Calculator
    def compute(object = nil)
      case object
      when Spree::LensMetaPrescription
        @order = object.order
        @lens_meta_prescription = object
      when Spree::Order
        @order = object
        @lens_meta_prescription = object.lens_meta_prescription
      end
      @lens_prescription = @lens_meta_prescription.lens_prescription
      if @lens_meta_prescription.glasses_type.to_s.in?(Spree::LensMetaPrescription::GLASSES_TYPE.map { |gt| gt.to_s })
        send(@lens_meta_prescription.glasses_type.to_s + '_amount') * @order.item_count# + @lens_meta_prescription.rowley_care_subscription_amount
      else
        0.0
      end
    end

    private

    def prescription_optical_detailed
      case @lens_prescription.vision_type.to_s
      when 'single_vision'
        amount = Spree::Config.lp_prescription_optical_single_vision
        amount += case @lens_prescription.lens_type.to_s
                  when 'standard' 
                    Spree::Config.lp_prescription_optical_single_vision_standard +
                      if @lens_prescription.transition? then Spree::Config.lp_prescription_optical_single_vision_standard_transition else 0.0 end
                  when 'thin'
                    Spree::Config.lp_prescription_optical_single_vision_1_67 +
                      if @lens_prescription.transition? then Spree::Config.lp_prescription_optical_single_vision_1_67_transition else 0.0 end
                  else
                    0
                  end
      when 'progressive'
        amount = Spree::Config.lp_prescription_optical_progressive
        amount += case @lens_prescription.lens_type.to_s
                  when 'standard' 
                    Spree::Config.lp_prescription_optical_progressive_standard +
                      if @lens_prescription.transition? then Spree::Config.lp_prescription_optical_progressive_standard_transition else 0.0 end
                  when 'thin'
                    Spree::Config.lp_prescription_optical_progressive_1_67 +
                      if @lens_prescription.transition? then Spree::Config.lp_prescription_optical_progressive_1_67_transition else 0.0 end
                  else
                    0
                  end
      else
        0.0
      end
    end

    def prescription_optical_amount
      case @lens_meta_prescription.prescription_input_method.to_s
      when 'retrieve_my_prescription', 'enter_new_prescription'
        if @lens_meta_prescription.prescription_input_method.to_s == 'retrieve_my_prescription' && @lens_meta_prescription.user_lens_prescription_id.blank?
          0.0
        else
          prescription_optical_detailed
        end
      when 'upload_my_prescription', 'email_or_fax_prescription'
        prescription_optical_detailed
      when 'call_my_doctor'
        # select max rate ever
        Spree::Config.lp_prescription_optical_single_vision +
          Spree::Config.lp_prescription_optical_single_vision_standard
      else 
        0.0
      end
    end

    def prescription_sunglasses_detailed
      case @lens_prescription.vision_type.to_s
      when 'single_vision'
        amount = Spree::Config.lp_prescription_sunglasses_single_vision
        amount += case @lens_prescription.lens_type.to_s
                  when 'standard' 
                    Spree::Config.lp_prescription_sunglasses_single_vision_standard + 
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'custom_tint' then Spree::Config.lp_prescription_sunglasses_single_vision_standard_custom_tint else 0.0 end +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'polarized' then Spree::Config.lp_prescription_sunglasses_single_vision_standard_polarized else 0.0 end
                  when 'thin'
                    Spree::Config.lp_prescription_sunglasses_single_vision_1_67 +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'custom_tint' then Spree::Config.lp_prescription_sunglasses_single_vision_1_67_custom_tint else 0.0 end +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'polarized' then Spree::Config.lp_prescription_sunglasses_single_vision_1_67_polarized else 0.0 end
                  else
                    0
                  end
      when 'progressive'
        amount = Spree::Config.lp_prescription_sunglasses_progressive
        amount += case @lens_prescription.lens_type.to_s
                  when 'standard' 
                    Spree::Config.lp_prescription_sunglasses_progressive_standard +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'custom_tint' then Spree::Config.lp_prescription_sunglasses_progressive_standard_custom_tint else 0.0 end +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'polarized' then Spree::Config.lp_prescription_sunglasses_progressive_standard_polarized else 0.0 end
                  when 'thin'
                    Spree::Config.lp_prescription_sunglasses_progressive_1_67 +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s == 'custom_tint' then Spree::Config.lp_prescription_sunglasses_progressive_1_67_custom_tint else 0.0 end +
                      if @lens_prescription.standard_or_custom_tint_or_polarized.to_s== 'polarized' then Spree::Config.lp_prescription_sunglasses_progressive_1_67_polarized else 0.0 end
                  else
                    0
                  end
      else
        0.0
      end
    end

    def prescription_sunglasses_amount
      case @lens_meta_prescription.prescription_input_method.to_s
      when 'retrieve_my_prescription', 'enter_new_prescription'
        if @lens_meta_prescription.prescription_input_method.to_s == 'retrieve_my_prescription' && @lens_meta_prescription.user_lens_prescription_id.blank?
          0.0
        else
          prescription_sunglasses_detailed
        end
      when 'upload_my_prescription', 'email_or_fax_prescription'
        prescription_sunglasses_detailed
      when 'call_my_doctor'
        # select max rate ever
        Spree::Config.lp_prescription_sunglasses_single_vision +
          Spree::Config.lp_prescription_sunglasses_single_vision_standard
      else
        0.0
      end
    end

    def ready_made_readers_amount
      Spree::Config.lp_ready_made_readers.to_f
    end

    def frames_sunglasses_amount
      if @lens_meta_prescription.demo?
        Spree::Config.lp_frames_sunglasses_demo.to_f
      else
        amount = Spree::Config.lp_frames_sunglasses_sunglasses
        amount += Spree::Config.lp_frames_sunglasses_sunglasses_custom_tint if @lens_meta_prescription.standard_or_custom_tint_or_polarized.to_s == 'custom_tint'
        amount += Spree::Config.lp_frames_sunglasses_sunglasses_polarized if @lens_meta_prescription.standard_or_custom_tint_or_polarized.to_s == 'polarized'
        
        amount
      end
    end


  end
end

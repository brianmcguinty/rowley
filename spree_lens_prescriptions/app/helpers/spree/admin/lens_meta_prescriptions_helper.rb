module Spree
  module Admin
    module LensMetaPrescriptionsHelper

      def display_prescription(order)
        return 'HTO' if order.hto?
        return 'n/a' unless order.lens_meta_prescription.present?
        case order.lens_meta_prescription.glasses_type
          when 'prescription_optical' then
            'optical'
          when 'prescription_sunglasses' then
            'sun&nbsp;w/&nbsp;optical'
          when 'ready_made_readers' then
            'readers'
          when 'frames_sunglasses'
            'sun&nbsp;w/o'
          else ''
        end.html_safe
      end

    end
  end
end



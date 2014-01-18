FactoryGirl.define do
  factory :lens_prescription, :class => Spree::LensPrescription do
    factory :lenses_for_prescription_optical do
      glasses_type :prescription_optical
    end
    factory :lenses_for_prescription_sunglasses do
      glasses_type :prescription_optical
    end
  end
end

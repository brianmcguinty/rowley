Spree::AppConfiguration.class_eval do
  # prescription optical
  preference :lp_prescription_optical_single_vision, :decimal, :default => 129
  preference :lp_prescription_optical_single_vision_standard, :decimal, :default => 0
  preference :lp_prescription_optical_single_vision_standard_transition, :decimal, :default => 40
  preference :lp_prescription_optical_single_vision_1_67, :decimal, :default => 40
  preference :lp_prescription_optical_single_vision_1_67_transition, :decimal, :default => 100
  preference :lp_prescription_optical_progressive, :decimal, :default => 199
  preference :lp_prescription_optical_progressive_standard, :decimal, :default => 0
  preference :lp_prescription_optical_progressive_standard_transition, :decimal, :default => 90
  preference :lp_prescription_optical_progressive_1_67, :decimal, :default => 100
  preference :lp_prescription_optical_progressive_1_67_transition, :decimal, :default => 100
  # prescription sunglasses
  preference :lp_prescription_sunglasses_single_vision, :decimal, :default => 129
  preference :lp_prescription_sunglasses_single_vision_standard, :decimal, :default => 0
  preference :lp_prescription_sunglasses_single_vision_standard_custom_tint, :decimal, :default => 10
  preference :lp_prescription_sunglasses_single_vision_standard_polarized, :decimal, :default => 135
  preference :lp_prescription_sunglasses_single_vision_1_67, :decimal, :default => 40
  preference :lp_prescription_sunglasses_single_vision_1_67_custom_tint, :decimal, :default => 30
  preference :lp_prescription_sunglasses_single_vision_1_67_polarized, :decimal, :default => 135
  preference :lp_prescription_sunglasses_progressive, :decimal, :default => 199
  preference :lp_prescription_sunglasses_progressive_standard, :decimal, :default => 0
  preference :lp_prescription_sunglasses_progressive_standard_custom_tint, :decimal, :default => 10
  preference :lp_prescription_sunglasses_progressive_standard_polarized, :decimal, :default => 135
  preference :lp_prescription_sunglasses_progressive_1_67, :decimal, :default => 100
  preference :lp_prescription_sunglasses_progressive_1_67_custom_tint, :decimal, :default => 0
  preference :lp_prescription_sunglasses_progressive_1_67_polarized, :decimal, :default => 135
  # ready-made readers
  preference :lp_ready_made_readers, :decimal, :default => 129
  # frames/sunglasses
  preference :lp_frames_sunglasses_demo, :decimal, :default => 0
  preference :lp_frames_sunglasses_sunglasses, :decimal, :default => 99
  preference :lp_frames_sunglasses_sunglasses_custom_tint, :decimal, :default => 20
  preference :lp_frames_sunglasses_sunglasses_polarized, :decimal, :default => 135
  # subscription
  preference :lp_subscription_monthly_price, :decimal, :default => 5
  preference :lp_subscription_annual_price, :decimal, :default => 50
  preference :lp_subscription_discount_percent, :decimal, :default => 50
  # internal emails
  preference :prescription_details_required_email, :string, :default => 'admin@rowleyeyewear.com'
  # Preferences related to uploaded prescription settings
  preference :uploaded_copy_default_url, :string, :default => '/spree/uploaded_prescriptions/:hash/:basename.:extension'
  preference :uploaded_copy_path, :string, :default => ':rails_root/public/spree/uploaded_prescriptions/:hash/:basename.:extension'
  preference :uploaded_copy_url, :string, :default => '/spree/uploaded_prescriptions/:hash/:basename.:extension'
  # Lens Lab credentials
  preference :lp_lab_num, :string, :default => '299'
  preference :lp_customer_num, :string, :default => '299002'
  preference :lp_lab_email, :string, :default => 'rx@rfg.optical-online.com'
  preference :lp_lab_email_from, :string, :default => 'no-replay@rowleyeyewear.com'

end

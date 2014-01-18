class Spree::LensMetaPrescription < ActiveRecord::Base
 
  has_one :adjustment2, :class_name => 'Spree::Adjustment', :foreign_key => :source_id, :as => :source, :dependent => :destroy
  belongs_to :order
  has_one :lens_prescription, :as => :prescription_container, :inverse_of => :prescription_container
  belongs_to :user_lens_prescription, :class_name => 'Spree::LensPrescription', :foreign_key => 'user_lens_prescription_id'
  belongs_to :subscription

  calculated_adjustments
  before_validation :replace_lens_prescription_with_stored
  after_save :ensure_correct_adjustment
  before_save :update_detailed_for_prescription
  after_save :update_verification
  
  accepts_nested_attributes_for :lens_prescription

  GLASSES_TYPE = [:prescription_optical, :prescription_sunglasses, :ready_made_readers, :frames_sunglasses]  
  STRENGTH = (0.0..4.0).step(0.25)
  PRESCRIPTION_INPUT_METHOD = [ :retrieve_my_prescription, :enter_new_prescription, :upload_my_prescription, :email_or_fax_prescription, :call_my_doctor ]
  ANON_PRESCRIPTION_INPUT_METHOD = PRESCRIPTION_INPUT_METHOD - [:retrieve_my_prescription]

  attr_accessor :initial, :do_not_replace_with_stored
  attr_writer :purchase_subscription_yes_no

  attr_accessible :glasses_type, :strength, :custom_tint, :standard_or_custom_tint_or_polarized, 
    :prescription_input_method, :lens_prescription_attributes, :demo_or_sunglasses, :user_lens_prescription_id, 
    :tint, :purchase_subscription_yes_no, :purchase_subscription_period, :detailed_prescription, :purchase_subscription, :do_not_replace_with_stored, :polarized, :polarized_color, :demo
  validates_presence_of :user_lens_prescription, :if => :retrieve_prescription?
  validates :strength, :numericality => { :greater_than => 0.0 }, :if => -> { glasses_type.to_s == 'ready_made_readers' }

  def self.default(user = nil, options = {})
    n = new(options) #(:glasses_type => GLASSES_TYPE.first)
    n.initial = true
    # if user.present? && user.lens_prescriptions.any? 
    #   n.prescription_input_method = PRESCRIPTION_INPUT_METHOD.first
    #   n.user_lens_prescription_id = user.lens_prescriptions.first.id
    # else 
    #   n.prescription_input_method = ANON_PRESCRIPTION_INPUT_METHOD.first
    # end
    n.build_lens_prescription(Spree::LensPrescription.default_attributes)
    n.lens_prescription.initial = true
    n.lens_prescription.detailed = n.detect_detailed_for_prescription
    n
  end

  def self.default_demo
    n = new(:glasses_type => :frames_sunglasses, :demo => true)
    n.initial = true
    n.build_lens_prescription(Spree::LensPrescription.default_attributes)
    n.lens_prescription.initial = true
    n.lens_prescription.detailed = false
    n
  end

  def demo_or_sunglasses
    if demo?
      :demo
    else
      :sunglasses
    end
  end

  def standard_or_custom_tint_or_polarized=(value)
    @standard_or_custom_tint_or_polarized = value
    update_custom_tint
    update_polarized_color
  end

  def standard_or_custom_tint_or_polarized
    @standard_or_custom_tint_or_polarized || if tint.blank? || tint.to_s == 'standard' 
      if polarized.present?
        :polarized
      else
        :standard
      end
    else
      :custom_tint
    end
  end

  def custom_tint
    tint if tint.present? && tint.to_s != 'standard'
  end

  def custom_tint=(value)
    @custom_tint = value
    self.tint = if standard_or_custom_tint_or_polarized.to_s == 'custom_tint' && value.present? then value end
  end

  def update_custom_tint
    self.custom_tint = @custom_tint if @custom_tint.present?
  end

  def polarized_color
    polarized if custom_tint.blank? && polarized.present?
  end

  def polarized_color=(value)
    @polarized_color = value
    self.polarized = if standard_or_custom_tint_or_polarized.to_s == 'polarized' && value.present? then value end
  end

  def update_polarized_color
    self.polarized_color = @polarized_color if @polarized_color.present?
  end

  def demo_or_sunglasses=(value)
    self.demo = value.present? && value.to_s == 'demo'
  end

  def ensure_correct_adjustment
    if adjustment2
      # adjustment.originator = shipping_method
      adjustment2.label = "Lenses"
      adjustment2.save
    else
      self.create_adjustment("Lenses", order, self, true)
      reload #ensure adjustment is present on later saves
    end
  end

  def calculator
    Spree::Calculator::LensMetaPrescriptionAddition.new
  end

  def sunglasses?
    glasses_type.to_s.in?('prescription_sunglasses', 'frames_sunglasses')
  end

  def replace_lens_prescription_with_stored
    if !order.completed? && !do_not_replace_with_stored && !initial && 
        glasses_type.to_s.in?('prescription_optical', 'prescription_sunglasses') && 
        prescription_input_method.to_s == 'retrieve_my_prescription' &&
        user_lens_prescription.present?
      lens_prescription.assign_attributes(user_lens_prescription.attributes.select { |k, v| !k.in?('id', 'created_at', 'updated_at', 'prescription_container_id', 'prescription_container_type', 'status') }, :without_protection => true)
      lens_prescription.uploaded_copy = user_lens_prescription.uploaded_copy
      lens_prescription.save(:validate => false)
    end
  end

  def retrieve_prescription?
    glasses_type.to_s.in?('prescription_optical', 'prescription_sunglasses') && prescription_input_method.to_s == 'retrieve_my_prescription'
  end

  def purchase_subscription_yes_no
    @purchase_subscription_yes_no || if purchase_subscription.present?
      :yes
    else
      :no
    end
  end

  def purchase_subscription_period
    purchase_subscription if purchase_subscription.present?
  end

  def purchase_subscription_period=(value)
    self.purchase_subscription = if purchase_subscription_yes_no.to_s == 'yes' && value.present? then value end
  end

  # def detailed_prescription
  #   prescription_based? && ((prescription_input_method.to_s == 'enter_new_prescription') ||
  #                          )

  # end

  def prescription_based?
    glasses_type.to_s.in?('prescription_optical', 'prescription_sunglasses')
  end

  def update_detailed_for_prescription
    if prescription_input_method_changed?
      case prescription_input_method.to_s
      when 'retrieve_my_prescription'
      when 'enter_new_prescription'
        lens_prescription.update_attribute(:detailed, true)
      else
        lens_prescription.update_attribute(:detailed, false)
      end
    end
  end

  def detect_detailed_for_prescription
    prescription_input_method.to_s == 'enter_new_prescription'
  end

  def rowley_care_subscription_amount
    case purchase_subscription.to_s
      when 'month'
        Spree::Config.lp_subscription_monthly_price
      when 'year'
        Spree::Config.lp_subscription_annual_price
      else
        0.0
    end
  end

  state_machine :initial => :verify do
    before_transition any => :sent_to_lab, :do => :send_rx_to_lab
    event :auto_verify do
      transition :verify => :pending, :if => lambda { |mp| !mp.prescription_based? || (mp.lens_prescription.detailed? && !mp.lens_prescription.verification_required?) }
    end

    event :verify_manually do
      transition :verify => :pending, :if => lambda { |mp| mp.prescription_based? && mp.lens_prescription.detailed? }
    end

    event :send_to_lab do
      transition :pending => :sent_to_lab
      transition :sent_to_lab => :sent_to_lab
    end
  end

  def send_rx_to_lab
    Spree::LensPrescriptionMailer.prescription_to_lab(self).deliver
  end

  def update_verification
    auto_verify if prescription_based? && order.complete? && lens_prescription.detailed?
  end

  def may_have_additional_charges?
    prescription_based? && prescription_input_method.present? && lens_prescription.present? && !lens_prescription.detailed?
  end
end

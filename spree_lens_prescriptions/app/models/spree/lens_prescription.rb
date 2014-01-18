class Spree::LensPrescription < ActiveRecord::Base
  belongs_to :prescription_container, :polymorphic => true
  belongs_to :state
  has_attached_file :uploaded_copy,
    :url => '/spree/uploaded_prescriptions/:hash/:basename.:extension', 
    :path => ':rails_root/public/spree/uploaded_prescriptions/:hash/:basename.:extension',
    :hash_secret => 'you can also configure your S3 credentials and other'
    #:styles => lambda { |a| { :thumb => "100x100#", :user_defined => "#{a.instance.width}x#{a.instance.height}#" }}

  after_save :update_verification

  include Spree::Core::S3Support
  supports_s3 :uploaded_copy

  #Spree::LensPrescription.attachment_definitions[:uploaded_copy][:styles] = ActiveSupport::JSON.decode(Spree::Config[:uploaded_copy_styles])
  self.attachment_definitions[:uploaded_copy][:path] = Spree::Config.uploaded_copy_path
  self.attachment_definitions[:uploaded_copy][:url] = Spree::Config.uploaded_copy_url
  self.attachment_definitions[:uploaded_copy][:default_url] = Spree::Config.uploaded_copy_default_url
  # Spree::LensPrescription.attachment_definitions[:uploaded_copy][:default_style] = Spree::Config[:uploaded_copy_default_style]

  VISION_TYPE = [:single_vision, :progressive]
  WEAR = [:higher_up_on_nose, :all_the_way_up_on_nose, :lower_down_on_nose]
  TINT = [:gray, :brown, :blue, :green, :rose]
  POLARIZED = [:gray, :brown]
  CUSTOM_TINT = TINT - [:standard]
  SPH = (-10..4).step(0.25)
  CYL = (-4..4).step(0.25)
  AXIS = (0..180).step(1.0)
  ADD = [0.0] + (1..3).step(0.25)
  PD = (50..80).step(0.5)
  MONO_PD = (25..40).step(0.5)
  LENS_TYPE = [:standard, :thin]
  VERIFICATION_METHOD = [:upload_copy, :email_or_fax, :contact_doctor]

  attr_accessor :initial

  # validates_presence_of :left_sph, :if => -> { glasses_type.to_sym.in?(:prescription_optical, :prescription_sunglasses) }
  belongs_to :prescription_container, :polymorphic => true
  attr_accessible :vision_type, :wear, :custom_tint, :polarized_color, :transition, :lens_type,
                  :two_pds, :right_sph, :right_cyl, :right_axis, :right_add, :right_pd, :left_sph, :left_cyl, :left_axis, :left_add, :left_pd, :pd,
                  :uploaded_copy, :state_id, :verification_method, :doctor_name, :doctor_phone, :patient_name, :patient_birth_date, :formatted_patient_birth_date, :name, 
                  :tint, :polarized, :wear_or_not_progressive, :detailed, :standard_or_custom_tint_or_polarized

  validates_presence_of :vision_type, :lens_type, :right_sph, :right_cyl, :right_axis, :right_add, :left_sph, :left_cyl, :left_axis, :left_add, :if => :optical_required?
  validates_presence_of :state_id, :state, :if => -> { !initial && optical_required? }
  validates_presence_of :left_pd, :right_pd, :if => Proc.new { |p| p.optical_required? && p.two_pds? }
  validates_presence_of :pd, :if => Proc.new { |p| p.optical_required? && !p.two_pds? }
  validates_attachment_presence :uploaded_copy, :if => :uploaded_copy_required?
  validates_attachment_size :uploaded_copy, :less_than => 10.megabytes
  validates_presence_of :doctor_name, :doctor_phone, :patient_name, :patient_birth_date, :formatted_patient_birth_date, :if => :doctor_required?
  validates_presence_of :verification_method, :if => :verification_required?

  before_validation :rollup_forced_thin_lenses
  # after_save :save_to_user # it will be saved on order complete
  after_save :sync_details_to_user

  scope :detailed, -> { where(:detailed => true) }

  def self.default
    new(default_attributes)
  end

  def self.default_attributes
    { 
      :vision_type => :single_vision, 
      :wear => WEAR.first, 
      # :tint => :standard, 
      :lens_type => :standard
    }
  end

  def meta
    prescription_container if prescription_container_type == 'Spree::LensMetaPrescription'
  end

  def user
    prescription_container if prescription_container_type == 'Spree::User'
  end

  def meta_is_prescription_based?
    meta && meta.prescription_based?
  end

  def optical_required?
    meta_is_prescription_based? && meta.prescription_input_method.to_s == 'enter_new_prescription'
  end

  def uploaded_copy_required?
    result = (optical_required? && state.present? && state.doctor_verification? && verification_method.to_s == 'upload_copy') || 
      (meta_is_prescription_based? && meta.prescription_input_method.to_s == 'upload_my_prescription')
    result
  end

  def save_to_user
    if meta && meta.prescription_based? && detailed? && 
        meta.prescription_input_method.to_s != 'retrieve_my_prescription' && 
        name.present? && meta.order.user.present?
      meta.order.user.lens_prescriptions.where(:name => name).destroy_all
      d = dup
      d.prescription_container = meta.order.user
      d.uploaded_copy = uploaded_copy
      d.save
    end
  end

  def sync_details_to_user
    if detailed? && meta && name.present? && meta.order.user.present? 
      if (user_prescription = meta.order.user.lens_prescriptions.where(:name => name).first) && !user_prescription.detailed?
        user_prescription.assign_attributes(attributes.select { |k, v| !k.in?('id', 'created_at', 'updated_at', 'prescription_container_id', 'prescription_container_type') }, :without_protection => true)
        user_prescription.uploaded_copy = uploaded_copy
        user_prescription.save(:validate => false)
      end
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

  def wear_or_not_progressive
    @wear_or_not_progressive || if vision_type.to_s == 'progressive'
      wear
    else
      :not_progressive
    end
  end

  def wear_or_not_progressive=(value)
    if value.present?
      if value.to_s == 'not_progressive'
        self.wear = nil
        self.vision_type = :single_vision
      else
        self.wear = value
        self.vision_type = :progressive
      end
    end
  end

  def doctor_required?
    (verification_required? && verification_method.to_s == 'contact_doctor') ||
      (meta && meta.prescription_based? && meta.prescription_input_method.to_s == 'call_my_doctor')
  end

  def verification_required?
    meta && meta.prescription_based? &&
      meta.prescription_input_method.to_s == 'enter_new_prescription' && 
      state.present? && state.doctor_verification?
  end

  def forced_thin?
    min_sph = -4.001
    max_sph = 4.001 
    min_cyl = -2.001
    right_sph < min_sph || left_sph < min_sph ||
      right_sph > max_sph || left_sph > max_sph ||
      right_cyl < min_cyl || left_cyl < min_cyl
  end

  def rollup_forced_thin_lenses
    self.lens_type = 'thin' if forced_thin?
  end

  def formatted_patient_birth_date
    patient_birth_date.strftime('%m/%d/%Y') if patient_birth_date.present?
  end

  def formatted_patient_birth_date=(value)
    self.patient_birth_date = if value.present? then Date.strptime(value, '%m/%d/%Y') end
  rescue
    self.patient_birth_date = nil
  end

  def left_axis_display
    '%03d' % left_axis
  end

  def right_axis_display
    '%03d' % right_axis
  end

  def progressive?
    vision_type.to_s == 'progressive'
  end

  def update_verification
    meta.update_verification if meta
  end

end

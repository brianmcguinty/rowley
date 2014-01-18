Spree::Address.class_eval do
  attr_accessible :email
  validates :email, :presence => true

  def empty?
    attributes.except('id', 'created_at', 'updated_at', 'order_id', 'country_id').all? { |_, v| (v.nil? || v.empty?) }
  end
end
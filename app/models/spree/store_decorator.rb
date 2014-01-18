Spree::Store.class_eval do
  scope :by_code,  ->(store_code)  { where(:code => store_code) }
end

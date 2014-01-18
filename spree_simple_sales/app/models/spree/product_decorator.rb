Spree::Product.class_eval do

  delegate_belongs_to :master, :sale_price if Spree::Variant.table_exists? && Spree::Variant.column_names.include?('sale_price')
  attr_accessible :sale_price

  delegate :has_sale_price?, to: :master
  delegate :orig_price_in, to: :master

  add_search_scope :has_sale_price do
    variants_table = Spree::Variant.table_name
    price_table = Spree::Price.table_name
    joins(:variants_including_master)
    .where("#{variants_table}.sale_price is not null")
    .joins(:prices)
    .where("#{variants_table}.sale_price > 0")
    .where("#{variants_table}.sale_price < #{price_table}.amount")
    .uniq
  end

  add_search_scope :has_not_sale_price do
    variants_table = Spree::Variant.table_name
    price_table = Spree::Price.table_name
    joins(:variants_including_master)
    .joins(:prices)
    .where("#{variants_table}.sale_price is null OR #{variants_table}.sale_price = 0 OR #{variants_table}.sale_price >= #{price_table}.amount")
    .uniq
  end

end
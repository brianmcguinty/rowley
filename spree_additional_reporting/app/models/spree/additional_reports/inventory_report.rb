module Spree::AdditionalReports
  class InventoryReport < Report
    def rows
      Spree::Variant.where(:is_master => false).order(:product_id)
    end
  end
end

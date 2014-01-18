module Spree::Search
  class MainApp < Spree::Core::Search::Base
    def get_base_scope
      #base_scope = @cached_product_group ? @cached_product_group.products.active(current_currency) : Spree::Product.active(current_currency)
      base_scope =  Spree::Product.active(current_currency)
      base_scope = base_scope.by_store(current_store_id) if current_store_id
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?

      color_scope = base_scope.with_option_value('frames-color', keywords) unless keywords.blank?
      base_scope = color_scope unless color_scope.blank?

      sku_scope = base_scope.by_sku(keywords) unless keywords.blank?
      base_scope = sku_scope unless sku_scope.blank?

      tmp_scope = get_products_conditions_for(base_scope, keywords) unless keywords.blank?
      base_scope = tmp_scope unless tmp_scope.blank?

      base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]



      base_scope = add_search_scopes(base_scope)
      base_scope
    end

    def prepare(params)
      super
      @properties[:current_store_id] = params[:current_store_id]
    end
  end
end

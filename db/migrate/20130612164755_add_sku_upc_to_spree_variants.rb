class AddSkuUpcToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :sku_upc, :string
  end
end

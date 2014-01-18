class AddSameAsVariantIdToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :same_as_variant_id, :integer
    add_index :spree_variants, :same_as_variant_id
  end
end

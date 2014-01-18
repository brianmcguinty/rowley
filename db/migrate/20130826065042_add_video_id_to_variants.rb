class AddVideoIdToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :video_id, :string
  end
end

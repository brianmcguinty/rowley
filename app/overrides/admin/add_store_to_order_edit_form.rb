Deface::Override.new(
  :virtual_path => "spree/admin/orders/_form",
  :name => "multi_domain_admin_product_form_meta",
  :insert_before => "fieldset",
  :erb => %q{<div class="field eight columns"><%= f.label :stores, t("stores")%> <%= f.collection_select :store_id , Spree::Store.all, :id, :name %></div>},
  :disabled => false)
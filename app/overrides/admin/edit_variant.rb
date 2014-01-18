Deface::Override.new(:virtual_path => "spree/admin/variants/_form",
                    :name => "add_sku_upc",
                    :insert_top => "[data-hook='admin_variant_form_additional_fields'], #admin_variant_form_additional_fields[data-hook]",
                    :erb => %q{<div class="field" data-hook="sku_upc">
                                 <%= f.label :sku_upc, t(:sku_upc) %>
                                 <%= f.text_field :sku_upc, :class => 'fullwidth' %>
                              </div>},
                    :disabled => false)
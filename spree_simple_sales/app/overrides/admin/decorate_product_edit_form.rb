Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                    :name => "sale_price_field",
                    :insert_top => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
                    :partial => "spree/admin/products/sale_price",
                    :disabled => false)

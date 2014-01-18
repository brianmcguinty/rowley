Deface::Override.new(:virtual_path => "spree/admin/products/index",
                    :name => "featured_products_index_header",
                    :replace_contents => "[data-hook='admin_products_index_headers'], #admin_products_index_headers[data-hook]",
                    :partial => "spree/admin/products/admin_products_index_headers",
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/products/index",
                    :name => "featured_products_index_rows",
                    :replace_contents => "[data-hook='admin_products_index_rows'], #admin_products_index_rows[data-hook]",
                    :partial => "spree/admin/products/admin_products_index_rows",
                    :disabled => false)
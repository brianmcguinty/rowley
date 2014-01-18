Deface::Override.new(:virtual_path => "spree/admin/images/index",
                    :name => "add_header_to_image_table",
                    :insert_before => "th.actions",
                    :text => %q{<th>Is "TryOn"</th><th>VTO image</th> },
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/images/index",
                    :name => "add_value_of_try_on_to_image_table_and_fix_images_set",
                    :replace_contents => "tbody",
                    :partial => "spree/admin/images/admin_images_listing_table",
                    :sequence => {:after => "add_header_to_image_table"},
                    :disabled => false)
Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs", 
                     :name => "add_lens_prescription_to_order_tabs",
                     :replace_contents => "[data-hook='admin_order_tabs']", 
                     :partial => 'spree/admin/shared/order_tabs_list',
                     :disabled => false)

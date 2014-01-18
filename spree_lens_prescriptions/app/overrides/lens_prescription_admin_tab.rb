Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                      :name => "add_lens_prescription_settings",
                      :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                      :text => "<%= configurations_sidebar_menu_item(t(:lens_prescription_settings), edit_admin_lens_prescription_settings_url) %>")

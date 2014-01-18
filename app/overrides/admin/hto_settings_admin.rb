Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                      :name => "add_hto_settings",
                      :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                      :text => "<%= configurations_sidebar_menu_item(t(:hto_settings), edit_admin_hto_settings_url) %>")

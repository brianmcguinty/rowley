Deface::Override.new(:virtual_path 		=> "spree/orders/show",
					 :name		   		=> "replace_orders_show",
					 :replace_contents	=> "fieldset#order_summary",
					 :erb				=> %q{<%= render :partial => 'spree/orders/custom_show' %>}
					)


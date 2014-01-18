Deface::Override.new(:virtual_path 		=> "spree/shared/_head",
					 :name		   		=> "replace_favicon",
					 :replace 		=> "code[erb-loud]:contains('favicon_link_tag')",
					 :erb 				=> %q{<%= favicon_link_tag image_path('favicon.png'), :type => 'image/png' %>})

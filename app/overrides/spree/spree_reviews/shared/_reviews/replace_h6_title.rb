Deface::Override.new(:virtual_path 		=> "spree/shared/_reviews",
					 :name		   		=> "replace_h6_title",
					 :replace 			=> "h6.product-section-title",
					 :erb				=> %q{<h2>Customer Reviews</h2>})
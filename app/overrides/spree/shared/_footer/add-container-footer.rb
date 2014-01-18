Deface::Override.new(:virtual_path 		=> "spree/shared/_footer",
					 :name		   		=> "add-container-footer",
					 :surround_contents => "#footer[data-hook]",
					 :erb 				=> %q{<div class="container"><div class="row"><%= render_original %></div></div>}
					)
Deface::Override.new(:virtual_path => "spree/shared/_search",
					 					 :name		   => "search_icon",
					 					 :replace => %q{code[erb-loud]:contains('submit_tag')},
					 					 :erb => %q{<span class="add-on"><i class="icon-search"></i></span>}
					 					 )
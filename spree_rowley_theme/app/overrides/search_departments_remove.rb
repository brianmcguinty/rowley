Deface::Override.new(:virtual_path => "spree/shared/_search",
					 					 :name		   => "search_departments_remove",
					 					 :remove => %q{code[erb-loud]:contains('select_tag')}
					 					 )

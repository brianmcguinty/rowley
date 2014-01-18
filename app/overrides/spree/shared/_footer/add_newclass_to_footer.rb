Deface::Override.new(:virtual_path 		=> "spree/shared/_footer",
                     :name 				=> "add_newclass_to_footer",
                     :set_attributes 	=> "#footer[data-hook]",
                     :attributes 		=> { :class => "row" })

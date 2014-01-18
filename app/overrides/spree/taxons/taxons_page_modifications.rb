Deface::Override.new(:virtual_path    	=> "spree/taxons/show",
                     :name		   	      => "add_class_to_taxon_header",
                     :add_to_attributes => "h1.taxon-title",
                     :attributes => {:class => 'center'})


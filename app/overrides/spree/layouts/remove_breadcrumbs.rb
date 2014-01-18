Deface::Override.new(:virtual_path 	=> "spree/layouts/spree_application",
					 :name		   	=> "remove_taxons_bradcrumbs",
					 :remove 		=> "code[erb-loud]:contains('breadcrumbs(@taxon)')")
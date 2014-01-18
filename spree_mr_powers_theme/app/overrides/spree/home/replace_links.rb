Deface::Override.new(:virtual_path 		=> "spree/home/index",
					 :name		   		=> "change_try_them_on_link",
			         :set_attributes 	=> "[data-hook='tryon-link'], #tryon-link[data-hook]",
			         :attributes 		=> {:href => '/try-on'})

Deface::Override.new(:virtual_path 		=> "spree/home/index",
					 :name		   		=> "change_rowley_care_link",
			         :set_attributes 	=> "a[data-hook='rowley-care-link'], a#rowley-care-link[data-hook]",
			         :attributes 		=> {:href => '/mrpowers-rowley-care'})

Deface::Override.new(:virtual_path 		=> "spree/home/index",
					 :name		   		=> "change_story_link",
			         :set_attributes 	=> "a[data-hook='story-link'], a#story-link[data-hook]",
			         :attributes 		=> {:href => '/mrpowers-story'})

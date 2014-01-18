Deface::Override.new(:virtual_path 	=> "spree/shared/_footer",
					 :name		   	=> "change_try_them_on_link",
           :set_attributes => "[data-hook='try-on-link'], #try-on-link[data-hook]",
           :attributes => {:href => '/try-on'})

Deface::Override.new(:virtual_path 	=> "spree/shared/_footer",
					 :name		   	=> "change_story_link",
           :set_attributes => "a[data-hook='story-link'], a#story-link[data-hook]",
           :attributes => {:href => '/mrpowers-story'})

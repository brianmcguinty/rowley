Deface::Override.new(:virtual_path 	=> "spree/checkout/registration",
					 :name		   	=> "registration_change_rowley_care_link",
           :set_attributes => "a[data-hook='rowley-care-link'], a#rowley-care-link[data-hook]",
           :attributes => {:href => '/mrpowers-rowley-care'})
Deface::Override.new(:virtual_path 		=> "spree/shared/_review",
 					 :name		   		=> "new_stars",
					 :replace_contents	=> "span.reviews-rating",
					 :erb				=> %q{<%= render :partial => "spree/reviews/stars_custom", :locals => {:stars => review.rating} %>})
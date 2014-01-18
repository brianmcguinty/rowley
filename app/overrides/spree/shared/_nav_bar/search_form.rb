Deface::Override.new(:virtual_path 	=> "spree/shared/_nav_bar",
					 :name		   	=> "search_form",
					 :insert_after 	=> "ul#nav-bar",
					 :erb 			=> %q{<div id="search-bar" data-hook> <%= render :partial => 'spree/shared/search' %></div>})

Deface::Override.new(:virtual_path 	=> "spree/shared/_nav_bar",
					 :name		   	=> "welcome_back",
					 :insert_after 	=> "#search-bar",
					 :erb 			=> %q{<%= render :partial => 'spree/shared/welcome_back' %>},
					 :sequence 	 	=> {:after => 'search_form'})
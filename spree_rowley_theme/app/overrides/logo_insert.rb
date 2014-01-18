Deface::Override.new(:virtual_path => "spree/shared/_nav_bar",
					 :name		   => "logo_insert",
					 :insert_after => "nav#top-nav-bar",
					 :erb => %q{<figure id="logo" class="columns sixteen" data-hook><%= logo %></figure>})
					 
Deface::Override.new(:virtual_path 		=> "spree/shared/_nav_bar",
					 :name		   		=> "add_hto_cart_link",
					 :insert_bottom 	=> "ul#nav-bar",
					 :erb				=> %q{
<li id="link-to-hto-cart" data-hook><%= link_to_hto_cart %></li>
<%= render :partial => 'spree/shared/hto_cart' %>
})

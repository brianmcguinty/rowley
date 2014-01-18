Deface::Override.new(:virtual_path 		=> "spree/shared/_nav_bar",
					 :name		   		=> "top_nav_bar_add_class",
					 :set_attributes 	=> "nav#top-nav-bar",
					 :attributes 	 	=> { :class => "row"})

Deface::Override.new(:virtual_path 		=> "spree/shared/_nav_bar",
					 :name		   		=> "add_cart_link",
					 :insert_bottom 	=> "ul#nav-bar",
					 :erb				=> %q{<li id="link-to-livechart">
                            <div data-id="1fa3810f73" class="livechat_button"><a href="http://www.livechatinc.com/">live chat software</a></div>

                            </li>
					 						  <li id="link-to-cart" data-hook><%= link_to_cart_without_sum %></li>
					 						  <%= render :partial => 'spree/shared/custom_cart' %>
					 						 }
					)

Deface::Override.new(:virtual_path 		=> "spree/shared/_nav_bar",
					 :name		   		=> "add_links",
					 :insert_top 	=> "ul#nav-bar",
					 :erb				=> %q{<li><a href="/customer-service">Contact</a></li>
					 						  <li><a href="/help_faq">Help/FAQ</a></li>}
					)
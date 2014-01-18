Deface::Override.new(:virtual_path 		=> "spree/orders/edit",
					 :name		   		=> "add_class_to_buttons",
					 :replace_contents 	=> "[data-hook='cart_buttons']",
					 :erb 	 			=> %q{<%= button_tag :class => 'btn-submit black', :id => 'update-button' do %>
            <%= t(:update) %>
          <% end %>
          <%= button_tag :class => 'button checkout btn-submit black', :id => 'checkout-link', :name => 'checkout' do %>
            <%= t(:checkout) %>
          <% end %>})
Deface::Override.new(:virtual_path 		=> "spree/orders/_adjustments",
					 :name		   		=> "remove_cart_adjustment_headers",
					 :remove 			=> "[data-hook='cart_adjustments_headers']"
					)

Deface::Override.new(:virtual_path 		=> "spree/orders/_adjustments",
					 :name		   		=> "replace_tbody_cart_adjustments",
					 :replace_contents	=> "tbody#cart_adjustments",
					 :erb 				=> %q{<% @order.adjustments.eligible.each do |adjustment| %>
											    <tr>
											      <td colspan="5"><%= adjustment.label %></td>
											      <td><%= adjustment.display_amount %></td>
											    </tr>
											  <% end %>}
					)
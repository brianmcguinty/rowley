Deface::Override.new(:virtual_path 		=> "spree/shared/_order_details",
					 :name		   		=> "replace_order_details",
					 :replace 			=> "[data-hook='order_details']",
					 :erb				=> %q{<%= render :partial => 'spree/shared/custom_order_details', :locals => { :order => @order } %>}
					)

Deface::Override.new(:virtual_path 		=> "spree/shared/_order_details",
					 :name		   		=> "remove_hr",
					 :remove 			=> "hr"
					)

Deface::Override.new(:virtual_path 		=> "spree/shared/_order_details",
					 :name		   		=> "replace_payment_info",
					 :replace 			=> "div.payment-info",
					 :erb				=> %q{
					 							<% if order.credit_cards.empty? %>
											        <%= content_tag(:span, order.payment.payment_method.name) if order.payment %>
											      <% else %>
											        <div class="cc-type float-left">
											          <% unless (cc_type = order.credit_cards.first.cc_type).blank? %>
											            <%= image_tag "credit_cards/icons/#{order.credit_cards.first.cc_type}.png" %>
											          <% end %>
											        </div>
											        
											        <div class="float-left">
												        <div class="full-name ordershow-payment">
												          <span><%= t(:ending_in)%> <%= order.credit_cards.first.last_digits %></span>
												          <br>
												          <%= order.credit_cards.first.first_name %>
												          <%= order.credit_cards.first.last_name %>
												        </div>
												    </div>
											        <div class="clearfix"></div>
											      <% end %>

					 					   %>}
					)


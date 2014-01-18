Deface::Override.new(:virtual_path => 'spree/layouts/admin', 
                     :name => 'add_unlock_order_admin',
                     :insert_top => '[data-hook="toolbar"] > .inline-menu', 
                     :erb => %q{
  <% if @order.present? && @order.is_a?(Spree::Order) && @order.locked? %> 
    <% if @order.can_unlock?(current_user) %>
      <li><%= link_to t(:unlock_order), admin_order_unlock_path(@order), :class => 'button' %></li>
    <% else %>
      <li style="color:red">Locked by <%= @order.locked_by_user.email %></li>
    <% end %>
  <% end %>
})

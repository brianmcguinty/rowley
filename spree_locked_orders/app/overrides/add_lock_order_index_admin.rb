Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_lock_order_index_admin_head",
                      :insert_before => '[data-hook="admin_orders_index_headers"] > th[data-hook="admin_orders_index_header_actions"]',
                      :text => "<th>Lock</th>"
                    )
Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_lock_order_index_admin_row",
                      :insert_before => '[data-hook="admin_orders_index_rows"] > td[data-hook="admin_orders_index_row_actions"]',
                      :erb => %q{

<td>
  <% if order.present? && order.is_a?(Spree::Order) && order.locked? %> 
    <% if order.can_unlock?(current_user) %>
      <% if order.locked_by_user.id =! current_user.id %>
        <span style="color:red"><%= order.locked_by_user.email %></span>
      <% end %>
      <%= link_to t(:unlock), admin_order_unlock_path(order), :class => 'state complete btn-unlock' %>
    <% else %>
      <span style="color:red"><%= order.locked_by_user.email %></span>
    <% end %>
  <% end %>
</td>
})

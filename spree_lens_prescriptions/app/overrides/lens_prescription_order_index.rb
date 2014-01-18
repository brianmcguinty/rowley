Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_lens_prescription_to_orders_index_head",
                      :insert_before => '[data-hook="admin_orders_index_headers"] > th[data-hook="admin_orders_index_header_actions"]',
                      :text => "<th>Prescription</th>"
                    )
Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_lens_prescription_to_orders_index_row",
                      :insert_before => '[data-hook="admin_orders_index_rows"] > td[data-hook="admin_orders_index_row_actions"]',
                      :erb => %q{
<td>
<% if order.lens_meta_prescription.present? %>
  <% if order.lens_meta_prescription.sent_to_lab? %>
    <%= link_to t("lens_prescription.state.#{order.lens_meta_prescription.state}"), admin_order_lens_prescription_url(order), :class => 'state complete' %>
  <% else %>
    <%= link_to t("lens_prescription.state.#{order.lens_meta_prescription.state}"), if order.locked? then admin_order_lens_prescription_url(order) else edit_admin_order_lens_prescription_url(order) end, :class => 'state backorder' %>
  <% end %>
  <%= display_prescription(order) %>
<% end %>
</td>
})

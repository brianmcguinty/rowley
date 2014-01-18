Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_hto_to_orders_index_head",
                      :insert_before => '[data-hook="admin_orders_index_headers"] > th[data-hook="admin_orders_index_header_actions"]',
                      :text => "<th>Home Try On</th>"
                    )
Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_hto_to_orders_index_row",
                      :insert_before => '[data-hook="admin_orders_index_rows"] > td[data-hook="admin_orders_index_row_actions"]',
                      :erb => %q{
<td>
<% if order.hto? && order.completed? && order.hto_state.present? && order.hto_state != 'unavailable' %>
  <%= link_to "#{t("hto_state.#{order.hto_state}")}#{if order.hto_overdue? then ": #{order.hto_overdue_days} #{'day'.pluralize(order.hto_overdue_days)}" end}", admin_order_url(order), :class => "state #{if order.hto_state == 'overdue' then 'void' elsif order.hto_completed? then 'complete' else 'pending' end}" %>
  a/capture:&nbsp;<%= if order.hto_disabled_auto_capture? then 'OFF' else 'ON' end %>
<% end %>
</td>
})

Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_hto_state_filter_to_orders_index",
                      :insert_bottom => '[data-hook="admin_orders_index_search"] > div.alpha',
                      :erb => %q{
<div class="field">
  <%= label_tag nil, t(:hto_status) %>
  <%= f.select :hto_state_eq, [
    'ready', 
    'shipped', 
    'delivered', 
    'pending_return',
    'overdue', 
    'returned', 
    'paid'].map { |s| [t("hto_state.#{s}"), s]}, {:include_blank => true}, :class => 'select2' %>  
</div>
})

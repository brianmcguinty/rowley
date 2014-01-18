Deface::Override.new(:virtual_path => 'spree/admin/orders/show', 
                     :name => 'add_disable_auto_capture_admin',
                     :insert_before => 'code[erb-silent]:contains("content_for :page_actions")', 
                     :erb => %q{
<% content_for :page_actions do %>
  <li>
    <%= button_link_to t(:hto_disable_auto_capture), fire_admin_order_url(@order.number, { :e => 'hto_disable_auto_capture' }), :icon => 'icon-trash', :data => { :confirm => t(:are_you_sure) } if @order.hto? && !@order.hto_disabled_auto_capture %>  
  </li>
<% end %>
})

Deface::Override.new(:virtual_path => 'spree/admin/orders/edit', 
                     :name => 'add_disable_auto_capture_admin_edit',
                     :insert_before => 'code[erb-silent]:contains("content_for :page_actions")', 
                     :erb => %q{
<% content_for :page_actions do %>
  <li>
    <%= button_link_to t(:hto_disable_auto_capture), fire_admin_order_url(@order.number, { :e => 'hto_disable_auto_capture' }), :icon => 'icon-trash', :data => { :confirm => t(:are_you_sure) } if @order.hto? && !@order.hto_disabled_auto_capture %>  
  </li>
<% end %>
})


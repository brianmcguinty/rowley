Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
                      :name => "hto_status_order_summary_admin",
                      :insert_bottom => "[data-hook='order_tab_summary'] dl, #order_tab_summary[data-hook] dl",
                      :erb =>%q{
<% if @order.hto? && @order.completed? && @order.hto_state.present? && @order.hto_state != 'unavailable' %>
  <dt><%= t('hto_state.title') %>:</dt>
  <dd><span class="state <%= if @order.hto_state == 'overdue' then 'void' elsif @order.hto_completed? then 'complete' else 'pending' end %>"><%= t("hto_state.#{@order.hto_state}") %><%= if @order.hto_overdue? then ": #{@order.hto_overdue_days} #{'day'.pluralize(@order.hto_overdue_days)}" end %></span></dd>
  <dt><%= t('hto_auto_capture') %>:</dt>
  <dd><span class='state <%= if @order.hto_disabled_auto_capture? then 'pending' else 'complete' end %>'><%= @order.hto_disabled_auto_capture? ? 'OFF' : 'ON' %></span></dd>
<% end %> 
                      }) 

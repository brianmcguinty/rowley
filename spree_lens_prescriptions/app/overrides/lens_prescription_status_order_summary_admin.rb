Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
                      :name => "lens_prescription_status_order_summary_admin",
                      :insert_bottom => "[data-hook='order_tab_summary'] dl, #order_tab_summary[data-hook] dl",
                      :erb =>%q{
<dt><%= t('lens_prescription.state.title') %>:</dt>
<% if @order.lens_meta_prescription %>
  <dd><span class="state <%= if @order.lens_meta_prescription.sent_to_lab? then 'ready' else 'pending' end %>"><%= t("lens_prescription.state.#{@order.lens_meta_prescription.state}") %></span></dd>
<% else %>
  <dd><span><%= t('lens_prescription.no_prescription').html_safe %></span></dd>
<% end %>
                      }) 

# Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
#                       :name => "add_import_prescription_to_file_or_send_to_lab",
#                       :insert_bottom => "[data-hook='admin_order_tabs'], #admin_order_tabs[data-hook]",
#                       :erb => %q{ <% if @order.lens_meta_prescription.present? && @order.lens_meta_prescription.prescription_based? && @order.lens_meta_prescription.lens_prescription.detailed? %>
#                       <li<%== ' class="active"' if current == t(:download_prescription_as_rx) %>>
#                           <%= link_to t(:download_prescription_as_rx), admin_order_path(@order)+'.rx' %>
#                         </li>
#                       <% end %>
#                       },
#                       :sequence => {:after => 'add_lens_prescription_to_order_tabs'})

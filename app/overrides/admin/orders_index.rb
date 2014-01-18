Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_upc_to_orders_index_head",
                      :insert_before => '[data-hook="admin_orders_index_headers"] > th[data-hook="admin_orders_index_header_actions"]',
                      :text => "<th>UPC</th>"
                    )
Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "add_upc_values_to_orders_index_row",
                      :insert_before => '[data-hook="admin_orders_index_rows"] > td[data-hook="admin_orders_index_row_actions"]',
                      :erb => %q{<td>
                                  <%== order.line_items.map(&:variant).map(&:sku_upc).join("<br/>")%>
                                </td> })
Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                      :name => "hide_canceled_orders",
                      :insert_bottom => '[data-hook="admin_orders_index_search"] > div[class="omega four columns"]',
                      :erb => %q{
                        <div class="field checkbox">
                          <label>
                            <%= f.check_box :hide_canceled_orders, {:checked => @hide_canceled_orders}, '1', '' %>
                            <%= t(:hide_canceled_orders) %>
                          </label>
                        </div>
                       },

                      :disabled => false)
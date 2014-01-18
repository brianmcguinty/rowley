Deface::Override.new(:virtual_path => "spree/admin/variants/_form",
                    :name => "add_variant_same_as",
                    :insert_after => "[data-hook='admin_variant_form_additional_fields']",
                    :erb => %q{
                    <div class="label-block left six columns alpha omega">
                      <div class="field">
                        <%= f.label :same_as_variant_id, t(:same_as_variant) %>
                        <%= f.collection_select :same_as_variant_id, Spree::Variant.same_as_parent.order(:sku), :id, :sku_with_linked, :include_blank => true, :class => 'fullwidth' %>
                      </div>
                      <% if f.object.persisted? && f.object.linked_variants.count > 1 %>
                        <div class="field">
                          <table>
                            <tr>
                              <th>Linked Variant</td>
                              <th>On Hand</td>
                            </tr>
                            <% f.object.linked_variants.each do |v| %>
                              <tr>
                                <td>
                                  <% if v.id == f.object.id %>
                                    <%= v.sku %>
                                  <% else %>
                                    <%= link_to v.sku, edit_admin_product_variant_path(v.product, v) %>
                                  <% end %>
                                </td>
                                <td><%= v.on_hand %></td>
                              </tr>
                            <% end %>
                          </table>
                          <%= f.check_box :allocate_inventory_flag %>
                          <span>Allocate units</span>
                          <%= f.text_field :allocate_inventory_qty %>
                        </div>
                      <% end %>
                    </div>
                    },
                    :disabled => false)

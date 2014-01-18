Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                    :name => "featured_product_checkbox",
                    :insert_top => "[data-hook='admin_product_form_additional_fields'], #admin_product_form_additional_fields[data-hook]",
                    :partial => "spree/admin/products/admin_product_featured_checkbox",
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                    :name => "is_new_product_checkbox",
                    :insert_after => "[data-hook='featured'], #featured[data-hook]",
                    :partial => "spree/admin/products/admin_product_is_new_checkbox",
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/shared/_product_tabs",
                    :name => "add_head_turn_image_submenu",
                    :insert_bottom => "[data-hook='admin_product_tabs'], #admin_product_tabs[data-hook]",
                    :erb => %q{<li<%== ' class="active"' if current == 'Head Turn Images' %>>
                            <%= link_to_with_icon 'icon-picture', t(:head_turn_image), admin_product_head_turn_images_url(@product) %>
                          </li>},
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                    :name => "video_id_field",
                    :insert_bottom => "[data-hook='admin_product_form_right'], #admin_product_form_right[data-hook]",
                    :partial => "spree/admin/products/video_id",
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/products/edit",
                    :name => "list_on_ebay",
                    :insert_after => "code[erb-silent]:contains('content_for :page_actions do')",
                    :erb => %q{<% if @product.ebay_item_id.blank? %>
                              <li>
                                <%= button_link_to t('admin.add_to_ebay'), admin_product_add_product_on_ebay_url(@product), {:icon => 'icon-plus'} %>
                              </li>
                              <% end %>},
                    :disabled => false)


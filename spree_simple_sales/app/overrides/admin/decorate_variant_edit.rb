Deface::Override.new(:virtual_path => "spree/admin/variants/_form",
                    :name => "add_sale_price",
                    :insert_after => "[data-hook='cost_price'], #cost_price[data-hook]",
                    :erb => %q{<div class="field" data-hook="sale_price">
                                 <%= f.label :sale_price, t(:sale_price) %>
                                 <%= f.text_field :sale_price, :class => 'fullwidth' %>
                              </div>},
                    :disabled => false)
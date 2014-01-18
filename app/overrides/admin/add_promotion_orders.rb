Deface::Override.new(:virtual_path => 'spree/admin/promotions/edit',
                    :name => 'add_promotion_orders',
                    :insert_after => '#promotion-filters',
                    :erb => %q{
<fieldset>
  <legend>Orders Applied to</legend>
  <div alpha eight columns>
    <table class="index">
      <thead data-hook="rma_header">
        <tr>
          <th>Date</th>
          <th><%= t(:number, :scope => 'activerecord.attributes.spree/order') %></th>
          <th><%= t(:state, :scope => 'activerecord.attributes.spree/order') %></th>
          </tr>  
      </thead>
      <tbody>
        <% @promotion.orders.each do |order| %>
          <tr class="<%= cycle('odd', 'even')%>">
            <td class="align-center"><%= l (order.completed? ? order.completed_at : order.created_at).to_date %></td>
            <td><%= link_to order.number, admin_order_path(order) %></td>
            <td class="align-center"><span class="state <%= order.state.downcase %>"><%= t("order_state.#{order.state.downcase}") %></span></td>
          </tr>
        <% end %>
      </tbody>
    </table>
  </div>
</fieldset>
},
                    :disabled => false)

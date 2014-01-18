Deface::Override.new(:virtual_path => "spree/admin/users/index",
                      :name => "add_subscription_to_index_head",
                      :insert_before => '[data-hook="admin_users_index_header_actions"]',
                      :erb => "<th><%= t(:subscription) %></th>")
Deface::Override.new(:virtual_path => "spree/admin/users/index",
                      :name => "add_subscription_to_index_rows",
                      :insert_before => '[data-hook="admin_users_index_row_actions"]',
                      :erb => %q[
<td><%= if user.active_subscription then t(user.active_subscription.period) end%></td>
])
Deface::Override.new(:virtual_path => "spree/admin/users/show",
                      :name => "add_subscription_to_show",
                      :insert_after => '[data-hook="roles"]',
                      :erb => %q[
<% if @user.active_subscription %>
<tr>                        
<th><%= t(:subscription) %></th>
<td>
<%= t(@user.active_subscription.period) %>
, <%= t(:start_date) %>: 
<%= t(@user.active_subscription.started_at) %>
</td>
</tr>                        
<% end %>
])
Deface::Override.new(:virtual_path => "spree/admin/users/edit",
                     :name => "add_subscription_to_edit_form",
                     :insert_after => "[data-hook='admin_user_edit_general_settings']",
                     :erb => %q[
<fieldset class="omega six columns">
  <legend><%= t(:subscription) %></legend>

  <% subscription = @user.active_subscription %>
  <% #subscription = @user.subscriptions.last %>
  <% if subscription.present? %>
    <div class="field">
      <%= t(:period) %>:
      <%= t(subscription.period) %>
      , <%= t(:start_date) %>: 
      <%= subscription.started_at %>
      ,
      <%= t(:status) %>:
      <%= t(subscription.status) %>
    </div>
    <div class="filter-actions actions">
      <%= link_to t(:cancel), admin_user_cancel_subscription_path(@user), :confirm => 'Are you sure?', :class => 'icon-trash button' %>
    </div>
  <% else %>
    <div class="no-objects-found"><%= t(:no_subscription) %></div>
  <% end %>
</fieldset>
])

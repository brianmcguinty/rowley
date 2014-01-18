Deface::Override.new(:virtual_path => 'spree/layouts/admin',
                     :name => 'admin_nested_layout',
                     :replace_contents => '#content[data-hook]',
                     :erb => %q{
<div class="<%= 'with-sidebar ' if content_for?(:sidebar) %>" id="content" data-hook>

  <% if content_for?(:table_filter) %>
    <div id="table-filter" data-hook class="<%= if content_for?(:sidebar) then 'twelve' else 'sixteen' end %> columns">
      <fieldset>
        <legend align="center"><%= yield :table_filter_title %></legend>
        <%= yield :table_filter %>
      </fieldset>
    </div>
  <% end %>

  <div class="<%= if content_for?(:sidebar) then 'twelve' else 'sixteen' end %> columns">
    <% if content_for?(:content) %>
      <%= yield :content %>
    <% else %>
      <%= yield %>
    <% end %>
  </div>

  <% if content_for?(:sidebar) %>
    <aside id="sidebar" data-hook class="four columns">

      <% if content_for?(:sidebar_title) %>
        <h5 class="sidebar-title"><span><%= yield :sidebar_title %></span></h5>
      <% end %>

      <%= yield :sidebar %>
    </aside>
  <% end %>

</div> }, :disabled => false)

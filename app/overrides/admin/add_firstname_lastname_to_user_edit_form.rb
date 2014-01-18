Deface::Override.new(
  :virtual_path => 'spree/admin/users/_form',
  :name => 'multi_domain_admin_product_form_meta',
  :insert_top => '[data-hook="admin_user_form_fields"] div:first-child',
  :erb => %q{
    <%= f.field_container :firstname do %>
      <%= f.label :firstname, t(:first_name) %>
      <%= f.text_field :firstname, :class => 'fullwidth' %>
      <%= error_message_on :user, :firstname %>
    <% end %>
    <%= f.field_container :lastname do %>
      <%= f.label :lastname, t(:last_name) %>
      <%= f.text_field :lastname, :class => 'fullwidth' %>
      <%= error_message_on :user, :lastname %>
    <% end %>
}, :disabled => false)

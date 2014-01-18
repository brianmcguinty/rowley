Deface::Override.new(:virtual_path => "spree/admin/shared/_address_form",
                    :name => "add_email_to_addresses",
                    :insert_bottom => "[data-hook='address_fields']",
                    :erb => %q{
<div class="field">
  <%= f.label :email, t(:email) + ':' %>
  <%= f.text_field :email, :class => 'fullwidth' %>
</div>  
})

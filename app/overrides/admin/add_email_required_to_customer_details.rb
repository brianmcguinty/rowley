Deface::Override.new(:virtual_path => 'spree/admin/orders/customer_details/_form',
                    :name => 'add_email_required_to_customer_details',
                    :insert_bottom => '[data-hook="customer_fields"]',
                    :erb => %q{
<div class="field">
  <%= hidden_field_tag 'order[email_required]', true %>
</div>  
})

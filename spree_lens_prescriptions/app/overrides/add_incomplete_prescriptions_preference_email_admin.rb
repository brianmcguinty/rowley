Deface::Override.new(:virtual_path => "spree/admin/general_settings/edit", 
                     :name => "add_incomplete_prescriptions_preference_email_admin",
                     :insert_top => "#preferences[data-hook] > fieldset", 
                     :erb => %q{
          <div class="field">
            <%= label_tag(:prescription_details_required_email, t(:prescription_details_required_email) + ': ') + tag(:br) %>
            <%= preference_field_tag(:prescription_details_required_email, Spree::Config[:prescription_details_required_email], :type => :string) %>
          </div>
})

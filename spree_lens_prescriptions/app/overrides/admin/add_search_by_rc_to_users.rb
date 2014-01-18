Deface::Override.new(:virtual_path => "spree/admin/users/index",
                     :name => "add_search_condition_by_rc_to_users",
                     :insert_before => "#admin_users_index_search_buttons[data-hook], [data-hook='admin_users_index_search_buttons']",
                     :erb => %q{
          <div class="field checkbox">
            <label>
              <input id="q_subscriptions_status_in" name="q[subscriptions_status_in]" type="checkbox" value="active">
              <%= t(:subscribed_to_rc) %>
            </label>
          </div>
})
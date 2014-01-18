Deface::Override.new(:virtual_path => "spree/admin/images/edit",
                    :name => "correct_image_size",
                    :replace_contents => "[data-hook='thumbnail'], #thumbnail[data-hook]",
                    :erb => %q{<%= f.label t(:thumbnail) %><br>
                          <%= link_to image_tag(@image.attachment.url(:mini)), @image.attachment.url(:product) %>},
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/images/edit",
                    :name => "add_try_on_checkbox",
                    :insert_before => "div.clear",
                    :erb => %q{<div class="field checkbox"> <label>
  <%= f.check_box :try_on_photo, {checked: @image.try_on_photo? } %>
  <%= t(:try_on_photo)%>
</label></div>},
                    :disabled => false)

Deface::Override.new(:virtual_path => "spree/admin/images/edit",
                    :name => "add_vto_checkbox",
                    :insert_before => "div.clear",
                    :erb => %q{<div class="field checkbox"> <label>
  <%= f.check_box :vto_image, {checked: @image.vto_image? } %>
  <%= t(:vto_image)%>
</label></div>},
                    :disabled => false)




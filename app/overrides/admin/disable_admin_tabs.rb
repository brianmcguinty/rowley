# promo
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "promo_admin_tabs",
                     :disabled => true)
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "promo_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:promotions, :url => spree.admin_promotions_path, :icon => 'icon-bullhorn') if can?(:manage, :all) %>",
                     :disabled => false)
                     
# banners
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                      :name => "banner_box_admin_tab",
                      :disabled => true)
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                      :name => "banner_box_admin_tab2",
                      :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                      :text => "<%= tab(:banner_boxes, :icon => 'icon-bookmark') if can?(:manage, :all) %>",
                      :disabled => false,
                      :sequence => { :after => 'banner_box_admin_tab' })

# static pages
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "static_content_admin_tab",
                     :disabled => true)
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "static_content_admin_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= tab(:pages, :icon => 'icon-file') if can?(:manage, :all) %>",
                     :disabled => false)
# users
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :disabled => true)
Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "user_admin_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:users, :url => spree.admin_users_path, :icon => 'icon-user') if can?(:manage, Spree::User) %> ",
                     :disabled => false,
                     :original => 'e49127029c733dcaf154ad0bd59102b63c57ac0b')

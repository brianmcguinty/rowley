Deface::Override.new(:virtual_path      => "spree/home/index",
                    :name               => "replace_home_products_listing",
                    :replace_contents   => "[data-hook='mainpage_products'], #homepage_products[data-hook]",
                    :erb				=> %q{<%= render :partial => 'spree/shared/home_products_list', :locals => { :products => @products } %>},
                    
                    :disabled           => false)




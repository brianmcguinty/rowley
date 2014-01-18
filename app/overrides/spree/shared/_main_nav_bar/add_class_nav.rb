Deface::Override.new(:virtual_path   => "spree/shared/_main_nav_bar",
                     :name           => "add_class_nav",
                     :set_attributes => "nav",
                     :attributes     => {:class => "row"})

Deface::Override.new(:virtual_path  => "spree/shared/_main_nav_bar",
                     :name          => "link-to-cart-del",
                     :remove        => "li#link-to-cart")

Deface::Override.new(:virtual_path  => "spree/shared/_main_nav_bar",
                     :name          => "remove-home-link",
                     :remove        => "li#home-link",
                     :disabled      => true
					)


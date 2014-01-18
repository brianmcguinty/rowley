Deface::Override.new(:virtual_path 	=> 'spree/products/index',
					 :name		   	=> 'banner_insert',
					 :insert_before => "[data-hook='homepage_products']",
					 :erb 			=> %q{<div class="row image-main">
				                          <%= banner_box(:category => "mrpowers_products", :style => 'full', :list => false, :options => {:width=>960, :height=>326, :interval=>7000}) %>
				                          </div>
					 					  <div class="row"><h2 class="center">The Collection</h2></div>})
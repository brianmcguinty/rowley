Deface::Override.new(:virtual_path 	=> 'spree/home/index',
					 :name		   	=> 'banner_insert_on_home_page',
					 :insert_top => "[data-hook='homepage_banners'], #homepage_banners[data-hook]",
					 :erb 			=> %q{ <%= banner_box(:category => "rowley_home", :style => 'full_home', :list => true, :options => {:width=>960, :height=>460, :interval=>7000}) %>},
           :disabled => false)
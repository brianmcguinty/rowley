Deface::Override.new(:virtual_path 	=> "spree/taxons/show",
                     :name		   	  => "add_banner_to_taxons_page",
                     :insert_before => "h1.taxon-title",
                     :erb           => %q{ <div class="row image-main"><%= banner_box(:category => "rowley_#{@taxon.name.downcase}", :style => 'full', :list => false, :options => {:width=>960, :height=>326, :interval=>7000}) %></div>} )

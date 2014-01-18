require 'csv'

namespace :rowley do
  desc 'Remove all products from database'
  task :clear_data => :environment do
    Spree::Product.where('created_at > "2013-01-01"').destroy_all
  end

  desc 'remove all records from spree_line_items table'
  task :clear_order_data => :environment do
    Spree::LineItem.where('created_at > "2013-01-01"').destroy_all
  end

  desc 'remove all images from products and variants'
  task :remove_images => :environment do
    Spree::Product.all.each do |product|
      product.variants.each do |variant|
        puts "Deleting images from variant: #{variant.sku}"
        variant.images.destroy_all
      end
      puts "Deleting images from product: #{product.sku}"
      product.images.destroy_all
    end
  end

  desc 'Assign color codes to variants'
  task :assign_fake_color_codes => :environment do
    # create option 'color_code' first
    option = Spree::OptionType.where(:name => 'color-code').first_or_create(:presentation => 'Color Code')
    frames_color = Spree::OptionType.where(:name => 'frames-color').first
    color_option_id = frames_color.id
    Spree::Variant.all.each do |v|
      next if v.is_master?
      puts "variant: #{v.sku}"
      v.product.option_types << option unless v.product.option_types.where(id: option.id).any?
      v.product.option_types << frames_color unless v.product.option_types.where(id: frames_color.id).any?
      id = v.option_values.where(:option_type_id => color_option_id).first.id
      v.set_option_value('color-code', sprintf("%04d",id%10000))
      v.save
    end

  end

  desc 'Upload images for existing variants and products'
  task :upload_images => :environment do
    upload_images
  end

  desc 'Update images for existing variants and products'
  task :update_images => :environment do
    upload_images(true)
  end

  desc 'Import data from CSV file'
  task :import_data => :environment do

    # set proper image sizes before import
    Spree::Config.set(:attachment_styles => '{"mini": "130x60>", "vto": "200x92>", "small": "407x190>", "product": "600x260>", "large": "2250x1050>"}')
    # Set image settings to process images
    Spree::Image.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Spree::Config[:attachment_styles])

    # Setup Multi Store configuration
    Spree::Store.by_code('rowley').first_or_create(
        :name             => 'RowleyEyeWear',
        :code             => 'rowley',
        :domains          => ['rowley.local','rowleyeyewear.com'].join("\n"),
        :default          => true,
        :default_currency => 'USD',
    )
    Spree::Store.by_code('mr_powers').first_or_create(
        :name             => 'Mr.Powers',
        :code             => 'mr_powers',
        :domains          => ['mr_powers.local','mrpowers.com'].join("\n"),
        :default          => false,
        :default_currency => 'USD',
    )

    import_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'import')

    if Dir.exists?(import_path)
      puts "Importing data from: #{import_path}"
      Dir.foreach(import_path) do |f|
        file_name = File.join(import_path, f)
        if File.file?(file_name)  && File.extname(file_name) === ".csv"
          puts "Loading data from #{f}"
          csv_file =File.read(file_name)
          csv = CSV.parse(csv_file, :headers => true, :col_sep => '|')  ## use alternate column separator :col_sep => '|'
          csv.each do |row|
            row = row.to_hash.with_indifferent_access
            puts  "SKU:#{row[:name]}"

            color_type = Spree::OptionType.where(:name=>'frames-color').first_or_create(:name=>'frames-color',:presentation=> 'Color')

            master_variant = Spree::Variant.where(:sku => row[:name]).first
            if master_variant.nil?
              product = Spree::Product.create(
                                :sku          => row[:name],
                                :name         => row[:display_name],
                                :price        => row[:price],
                                :on_hand      => 0,
                                :available_on => Time.now,
                                :featured     => row[:featured],
                                :is_new       => row[:is_new])
            else
              product = master_variant.product
            end

            product.description  = row[:description] if row[:description].present?
            product.option_type_ids << color_type.id
            product.set_property('shape',row[:shape]) unless row[:shape].nil?
            product.set_property('material',row[:material]) unless row[:material].nil?
            product.set_property('video_url',row[:video_url]) unless row[:video_url].nil?

            # Check store_code
            if row[:store_code].present?
              store = Spree::Store.by_code(row[:store_code]).first
              if !store.nil?
                puts "Binding #{product.name} to store #{store.code}"
                product.stores << store unless product.stores.include? store
              end
            end

            # Check Taxonomy
            if row[:taxonomy].present?
              category = Spree::Taxonomy.where(:name => row[:taxonomy]).first_or_create()
              #category.save
              taxon = Spree::Taxon.where(:name => category.name).first_or_create()
              puts "Linking product #{product.name} to category #{category.name}"
              product.taxons << taxon unless product.taxons.include?(taxon)
            end
            product.save!

            color_code = "#{row[:color].to_s.tr(' ', '_').upcase}"
            sku = "#{row[:name]}_#{color_code}"
            puts sku

            item = Spree::Variant.where(:sku => sku).first
            if item.nil?
              option_value = Spree::OptionValue.
                where(:name => color_code, :option_type_id => color_type.id).first_or_create
              option_value.presentation = row[:color]
              option_value.save

              item = Spree::Variant.create(:sku         => sku,
                                           :on_hand     => row[:qty],
                                           :width       => row[:w],
                                           :height      => row[:h],
                                           :depth       => row[:d],
                                           :product_id  => product.id)

              item.option_values << option_value
            end
         end
        end
      end

      ### upload images
      puts 'To upload images please run: rake rowley:upload_images'
      #upload_images(File.join(import_path,'images'))

    else
      puts 'Nothing to do'
      next
    end


  end

  def parse_csv_files(import_path)
    csv_array = []
    Dir.foreach(import_path) do |f|
      file_name = File.join(import_path, f)
      if File.file?(file_name)  && File.extname(file_name) === ".csv"
        puts "Loading data from #{f}"
        csv_file =File.read(file_name)
        csv_array << CSV.parse(csv_file, :headers => true, :col_sep => ',')  ## use alternate column separator :col_sep => '|'
      end
    end
    csv_array
  end

  def upload_images(update = false)
    path_to_images = File.join(File.dirname(__FILE__), '..', '..', 'db', 'import','images')
    if update
      path_to_images = File.join(File.dirname(__FILE__), '..', '..', 'db', 'update','images')
    end
    ####
    #  we should use filenames like CR5000.0.jpg(.png) or CR5000-BLACK.0.png, CR5000-BLACK.1.png. Suffix "0" or "1" will be used for set position number of different views of product
    #  if file name like CR5000.try_on.2.jpg(.png) - this image will be "tagged" as "try_on_photo"
    #
    # Styles for images should defined in admin area
    # #:styles => { :mini => '129x65>', :small => '349x129>', :product => '570x225>', :large => '960x326>' },
    # It can be done as overriding existing styles or by creating new one (see above)
    #
    ####
    puts "processing images from: #{path_to_images}"
    Dir.foreach(path_to_images) do |filename|
      img_name = File.basename(filename, '.*')
      # check on "try_on_photo" property

      # get position from image name
      position = File.extname(img_name).delete '.'
      #remove position from image name
      img_name = File.basename(img_name, '.*')
      # check on .TRY_ON
      try_on = false
      if File.extname(img_name).upcase.eql?(".TRY_ON") then
        puts "try_on image: #{img_name}"
        try_on = true
        # remove .TRY_ON from image name
        img_name = File.basename(img_name, '.*')
      end
      # check if image prepared for Virtual TryOn
      vto_image = false
      if File.extname(img_name).upcase.eql?(".VTO") then
        puts "VTO image: #{img_name}"
        vto_image = true
        # remove .VTO from image name
        img_name = File.basename(img_name, '.*')
      end

      variant = Spree::Variant.where(:sku => img_name.upcase).first
      unless variant.nil?
        if try_on
          image = variant.images.try_on_photo.offset(position).first
        elsif vto_image
          image = variant.images.vto_image.offset(position).first
        else
          image = variant.images.not_try_on_photo.not_vto_image.offset(position).first
        end

        if image.nil?
          # create new attachment
          Spree::Image.create(:attachment => File.open(File.join(path_to_images, filename)),
                              :viewable_id => variant.id,
                              :viewable_type => 'Spree::Variant',
                              :try_on_photo => try_on,
                              :position => position,
                              :vto_image => vto_image
          )
          puts "#{filename} attached to #{variant.sku}; position -> #{position}  "
        else
          #replace old attachment
          puts "replace image for #{variant.sku}, position: #{position}, vto: #{vto_image}, try_on: #{try_on}"
          image.attachment = File.open(File.join(path_to_images, filename));
          image.save
        end

      end
    end
  end

  task :update_data => :environment do
    import_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'update')
    csv_data = parse_csv_files import_path
    csv_data.each do |csv|
     csv.each do |row|
        row = row.to_hash.with_indifferent_access
        # find variant by sku
        color_code = "#{row[:color].to_s.strip.tr(' ', '_').tr('/','_').upcase}"
        sku = "#{row[:name]}_#{color_code}"
        puts  "SKU:#{sku}"
        item = Spree::Variant.where(:sku => sku).first
        if item.present?
          puts "Updating data of #{sku}"
          item.on_hand = row[:qty] if row[:qty].present?
          item.width = row[:w] if row[:w].present?
          item.height = row[:h] if row[:h].present?
          item.depth = row[:d] if row[:d].present?
          item.product.price = row[:price] if row[:price].present?
          item.product.set_property('material',row[:material]) unless row[:material].nil?
          item.product.set_property('shape',row[:shape]) unless row[:shape].nil?
          item.product.set_property('B',row[:B]) if row[:B].present?
          item.product.set_property('ED',row[:ED]) if row[:ED].present?
          #item.product.set_property('UPC',row[:UPC]) if row[:UPC].present?
          item.sku_upc = row[:UPC] if row[:UPC].present?
          item.product.set_property('lab_material',row[:lab_material]) if row[:lab_material].present?
          if row[:description].present?
            puts "saving description"
            item.product.description  = row[:description]
          end
          item.product.save
          item.save
        else
          puts "can't find variant #{sku} "
        end

      end
    end
  end

  desc 'import coupon codes from csv file'
  task :import_coupon_codes => :environment do
    import_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'coupon_codes')
    csv_data = parse_csv_files import_path
    csv_data.each do |csv|
      csv.each do |row|
        row = row.to_hash.with_indifferent_access
        puts "code: #{row[:code]}   value: #{row[:value]}"
        promo = Spree::Promotion.create(
          name: "Gilt Group",
          description: "Gilt Group coupon code",
          event_name: 'spree.checkout.coupon_code_added',
          match_policy: 'all',
          starts_at: DateTime.new(2013,9,16),
          expires_at: DateTime.new(2014,9,16),
          code: row[:code],
          usage_limit: 1
        )
        promo.promotion_actions << Spree::Promotion::Actions::CreateAdjustment.create(
            {calculator: Spree::Calculator::FlatRate.new(preferred_amount: row[:value])},
            without_protection: true)
        promo.save
      end
    end

  end

  task :import_countries_and_states => :environment do
    country = Spree::Country.new
    country.name = 'United States'
    country.iso3 = 'USA'
    country.iso = 'US'
    country.iso_name = 'UNITED STATES'
    country.numcode = '840'
    country.save!
    [
        {name: 'Michigan', abbr: 'MI', doctor_verification: false},
        {name: 'South Dakota', abbr: 'SD', doctor_verification: false},
        {name: 'Washington', abbr: 'WA', doctor_verification: true},
        {name: 'Wisconsin', abbr: 'WI', doctor_verification: false},
        {name: 'Arizona', abbr: 'AZ', doctor_verification: true},
        {name: 'Illinois', abbr: 'IL', doctor_verification: false},
        {name: 'New Hampshire', abbr: 'NH', doctor_verification: false},
        {name: 'North Carolina', abbr: 'NC', doctor_verification: true},
        {name: 'Kansas', abbr: 'KS', doctor_verification: false},
        {name: 'Missouri', abbr: 'MO', doctor_verification: false},
        {name: 'Arkansas', abbr: 'AR', doctor_verification: false},
        {name: 'Nevada', abbr: 'NV', doctor_verification: true},
        {name: 'District of Columbia', abbr: 'DC', doctor_verification: false},
        {name: 'Idaho', abbr: 'ID', doctor_verification: false},
        {name: 'Nebraska', abbr: 'NE', doctor_verification: false},
        {name: 'Pennsylvania', abbr: 'PA', doctor_verification: false},
        {name: 'Hawaii', abbr: 'HI', doctor_verification: false},
        {name: 'Utah', abbr: 'UT', doctor_verification: false},
        {name: 'Vermont', abbr: 'VT', doctor_verification: true},
        {name: 'Delaware', abbr: 'DE', doctor_verification: false},
        {name: 'Rhode Island', abbr: 'RI', doctor_verification: true},
        {name: 'Oklahoma', abbr: 'OK', doctor_verification: false},
        {name: 'Louisiana', abbr: 'LA', doctor_verification: false},
        {name: 'Montana', abbr: 'MT', doctor_verification: false},
        {name: 'Tennessee', abbr: 'TN', doctor_verification: true},
        {name: 'Maryland', abbr: 'MD', doctor_verification: false},
        {name: 'Florida', abbr: 'FL', doctor_verification: true},
        {name: 'Virginia', abbr: 'VA', doctor_verification: false},
        {name: 'Minnesota', abbr: 'MN', doctor_verification: false},
        {name: 'New Jersey', abbr: 'NJ', doctor_verification: true},
        {name: 'Ohio', abbr: 'OH', doctor_verification: true},
        {name: 'California', abbr: 'CA', doctor_verification: true},
        {name: 'North Dakota', abbr: 'ND', doctor_verification: false},
        {name: 'Maine', abbr: 'ME', doctor_verification: false},
        {name: 'Indiana', abbr: 'IN', doctor_verification: false},
        {name: 'Texas', abbr: 'TX', doctor_verification: false},
        {name: 'Oregon', abbr: 'OR', doctor_verification: false},
        {name: 'Wyoming', abbr: 'WY', doctor_verification: false},
        {name: 'Alabama', abbr: 'AL', doctor_verification: true},
        {name: 'Iowa', abbr: 'IA', doctor_verification: false},
        {name: 'Mississippi', abbr: 'MS', doctor_verification: false},
        {name: 'Kentucky', abbr: 'KY', doctor_verification: true},
        {name: 'New Mexico', abbr: 'NM', doctor_verification: false},
        {name: 'Georgia', abbr: 'GA', doctor_verification: true},
        {name: 'Colorado', abbr: 'CO', doctor_verification: false},
        {name: 'Massachusetts', abbr: 'MA', doctor_verification: true},
        {name: 'Connecticut', abbr: 'CT', doctor_verification: true},
        {name: 'New York', abbr: 'NY', doctor_verification: true},
        {name: 'South Carolina', abbr: 'SC', doctor_verification: true},
        {name: 'Alaska', abbr: 'AK', doctor_verification: true},
        {name: 'West Virginia', abbr: 'WV', doctor_verification: false}].each do |s|
      state = Spree::State.new
      state.country_id = country.id
      state.name = s[:name]
      state.abbr = s[:abbr]
      state.doctor_verification = s[:doctor_verification]
      state.save!
    end
  end

  task :clear_countries_and_states => :environment do
    Spree::State.destroy_all
    Spree::Country.destroy_all
  end

  desc 'import sale price for products from csv files from db/sale_prices folder'
  task :import_sale_prices => :environment do
    import_path = File.join(File.dirname(__FILE__), '..', '..', 'db', 'sale_prices')
    csv_data = parse_csv_files import_path
    csv_data.each do |csv|
      csv.each do |row|
        row = row.to_hash.with_indifferent_access
        puts "sku: #{row[:sku]}   price: #{row[:price]}"
        p = Spree::Product.joins(:master).where('spree_variants.sku = ?', row[:sku]).first
        p.variants_including_master.each do |v|
          v.update_attribute('sale_price', row[:price])
        end
      end
    end
  end

  desc 'clear all sales prices'
  task :clear_sale_prices => :environment do
    Spree::Variant.clear_sale_prices
  end

  end

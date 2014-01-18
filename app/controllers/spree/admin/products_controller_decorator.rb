Spree::Admin::ProductsController.class_eval do
  update.before :set_featured
  update.before :set_is_new

  require 'uri'
  require 'net/http'
  require 'net/https'

  def add_product_on_ebay
    @product = Spree::Product.find_by_permalink!(params[:product_id])
    ac = ActionController::Base.new
    request_xml = ac.render_to_string(:file => 'spree/admin/ebay_api/add_fixed_price_item', :format => :xml, :locals => {:product => @product})
    result = ebay_request(request_xml,'AddFixedPriceItem')
    if result[:success]
      @product.update_attribute('ebay_item_id',result[:item_id])
      flash.notice = "New item has been listed on eBay wit ID: #{result[:item_id]}"
    else
      flash[:error] = result[:error]
    end
    redirect_to edit_admin_product_url(@product)
    #respond_with(@product)
  end



  private
  def set_featured
    @product.featured = nil unless params[:product].key? :featured
  end

  def set_is_new
      @product.is_new = nil unless params[:product].key? :is_new
  end

  def ebay_request(xml,call_name)
    result = {:success => true}

    url = URI.parse(EBAY['api_url'])
    request = Net::HTTP::Post.new(url.path)

    ## initialise headers
    #request.content_type = 'text/html; charset=UTF-8'
    request.add_field 'X-EBAY-API-COMPATIBILITY-LEVEL', EBAY['compatibility_level']
    request.add_field 'X-EBAY-API-DEV-NAME', EBAY['dev_name']
    request.add_field 'X-EBAY-API-APP-NAME', EBAY['app_name']
    request.add_field 'X-EBAY-API-CERT-NAME', EBAY['cert_name']
    request.add_field 'X-EBAY-API-SITEID', EBAY['site_id']
    request.add_field 'X-EBAY-API-CALL-NAME', call_name

    ## create request body
    request.body = xml
    response = Net::HTTP.start(url.host, url.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) {|http| http.request(request)}
    if response.code == '200'
      @doc = Nokogiri::XML response.body
      ack = @doc.xpath('//xmlns:Ack').first.text
      if ack.downcase == 'failure'
        result[:success] = false
        result[:error] = @doc.xpath('//xmlns:Errors/xmlns:ShortMessage').first.text
      else
        result[:item_id] = @doc.xpath('//xmlns:ItemID').first.text if @doc.xpath('//xmlns:ItemID').first.present?
      end
    else
      result[:success] = false
      result[:error] = "Unknown error. eBay return error code #{response.code}"
    end
    result
  end

end
# encoding: utf-8
xml.instruct!
xml.AddFixedPriceItemRequest :xmlns => "urn:ebay:apis:eBLBaseComponents" do
  xml.RequesterCredentials do
    xml.eBayAuthToken EBAY['auth_token']
  end
  xml.ErrorLanguage 'en_US'
  xml.WarningLevel 'High'
  xml.Item do
    xml.Title product.name
    xml.Description product.description
    xml.PrimaryCategory do
      xml.CategoryID EBAY['category_id']
    end
    #xml.StartPrice product.price
    xml.CategoryMappingAllowed true
    #xml.ConditionID '1000'
    xml.Country 'US'
    xml.Currency 'USD'
    xml.DispatchTimeMax 3
    xml.ListingDuration 'Days_7'
    xml.ListingType 'FixedPriceItem'
    xml.PaymentMethods 'VisaMC'
    xml.PictureDetails do
      xml.PictureSource 'Vendor'
      product.images.not_vto_image.each do |image|
        xml.PictureURL "#{EBAY['images_host']}#{image.attachment.url(:product)}"
      end
  end
    xml.Variations do
      xml.Pictures do
        xml.VariationSpecificName 'Color'
        product.variants.each do |v|
          xml.VariationSpecificPictureSet do
            xml.VariationSpecificValue v.option_value('frames-color')
            v.images.not_vto_image.each do |image|
              xml.PictureURL "#{EBAY['images_host']}#{image.attachment.url(:product)}"
            end
          end
        end
      end
      product.variants.each do |v|
        xml.Variation do
          xml.Quantity v.on_hand
          xml.SKU v.sku
          xml.StartPrice v.price
          xml.VariationSpecifics do
            xml.NameValueList do
              xml.Name 'Color'
              xml.Value v.option_value('frames-color')
            end
          end
        end
      end
      xml.VariationSpecificsSet do
        xml.NameValueList do
          xml.Name 'Color'
          product.variants.each do |v|
            xml.Value v.option_value('frames-color')
          end
        end
      end
    end
    xml.ReturnPolicy do
      xml.ReturnsAcceptedOption 'ReturnsAccepted'
      xml.RefundOption 'MoneyBack'
      xml.ReturnsWithinOption 'Days_30'
      xml.Description 'If you are not satisfied, return the item for refund.'
      xml.ShippingCostPaidByOption 'Buyer'
    end
    xml.ShippingDetails do
      xml.CalculatedShippingRate do
        xml.OriginatingPostalCode EBAY['postal_code']
        xml.WeightMajor 2
        xml.WeightMinor 0
      end
      xml.ShippingType 'FlatDomesticCalculatedInternational'
      xml.ShippingServiceOptions do
        xml.ShippingServicePriority 1
        xml.ShippingService 'FedExHomeDelivery'
        xml.FreeShipping true
        xml.ShippingServiceAdditionalCost '0.00', 'currencyID' => 'USD'
      end
    end
    xml.Site 'US'
  end
end
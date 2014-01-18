module Spree
  module OneTimePopUpHelper

    def halloween_popup
      if Date.today == Date.new(2013,10,31) && session['halloween_banner_showed'].blank?
        session['halloween_banner_showed'] = true
        render 'spree/shared/halloween_popup'
      end
    end

    def holiday_popup(date_from, date_to, image_params)
      image_params[:widht] ||= 800
      image_params[:height] ||= 600
      if (date_from..date_to).cover?(DateTime.now) && session['holiday_popup_showed'].blank?
        session['holiday_popup_showed'] = true
        #render 'spree/shared/halloween_popup'
        render 'spree/shared/holiday_popup', image_params
      end
    end

  end

end

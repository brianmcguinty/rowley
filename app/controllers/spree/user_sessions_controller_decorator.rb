Spree::UserSessionsController.class_eval do
  ssl_allowed :cross_login

  def create
    authenticate_user!

    if user_signed_in?
      respond_to do |format|
        format.html {
          # flash[:success] = t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash.now[:error] = t('devise.failure.invalid')
      render :new
    end
  end

  def cross_login
    if signed_in? && params[:site].in?('rowley', 'mrpowers')
      token = Spree::CrossLoginToken.new
      token.user = current_user
      token.save
      host = case params[:site]
      when 'rowley'
        'www.rowleyeyewear.com'
        # 'rowleyeyewear.local:3000'
      when 'mrpowers'
        'www.mrpowerseyewear.com'
        # 'mrpowers.local:3000'
      end
      url = "http://#{host}/authenticate_by_cross_login_token?token=#{token.value}"
      url += "&url=#{CGI.escape(params[:url])}" if params[:url].present?
      redirect_to url 
    else
      redirect_to root_path
    end
  end

  def authenticate_by_cross_login_token
    if params[:token].present? && (token = Spree::CrossLoginToken.actual.where(:value => params[:token]).first)
      sign_in token.user
      token.deactivate
      redirect_to params[:url] || root_path
    else
      redirect_to root_path
    end

  end
end

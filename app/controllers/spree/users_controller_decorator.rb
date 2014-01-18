Spree::UsersController.class_eval do

  require 'spree_mail_chimp'
  include SpreeMailChimp::SharedMethods

  before_filter :load_addresses, :only => [:show]

  prepend_before_filter :load_object, :only => [:show, :edit, :update, :purchase_rc, :update_address]
  before_filter :init_cc_and_period, :only => [:show]

  def update
    respond_to do |wants|
      wants.html do
        if @user.update_attributes(params[:user])
          if params[:user][:password].present?
            # this logic needed b/c devise wants to log us out after password changes
            user = Spree::User.reset_password_by_token(params[:user])
            sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
          end
          redirect_to spree.account_url, :notice => t(:account_updated)
        else
          render :edit
        end
      end
      wants.js do
        if params[:mode].in?('change_password', 'change_email')
          if @success = @user.update_with_password(params[:user])
            sign_in(@user, :bypass => true)
            if params[:mode] == 'change_email'
              @user.new_email = nil
              @user.new_email_confirmation = nil
            end
            current_user.reload
          end
        else
          render :js => 'alert("Invalid update")'
        end
      end
    end

  end

  def update_address
    if @address = current_user.send("#{params[:address_type]}_address")
      @address.update_attributes(params[:address])
    else
      @address = current_user.send("build_#{params[:address_type]}_address", params[:address])
      if @address.save
        current_user.update_attribute("#{params[:address_type]}_address_id", @address.id)
      end
    end

    respond_to do |format|
      format.js { render :locals => {:address_type => params[:address_type]}}
    end

  end

  def purchase_rc
    @invalid = true
    @cc = Spree::CreditCard.new(params[:credit_card])
    @period = params[:period]
    @wrong_period = !@period.in?('year', 'month')
    if @cc.save && !@wrong_period
      if @user.register_subscription(@period, @cc)
        errors = subscribe_email_to_list @user.email, 'rowley-care' rescue false
        @invalid = false
      else
        @cc.errors.add(:number, 'Invalid subscription')
      end
    end
    respond_to do |wants|
      wants.js   
    end
    
  end

  def load_object
    @user ||= Spree::User.find_by_id(spree_current_user.id) if signed_in?
    authorize! params[:action].to_sym, @user
  end

  def load_addresses
    @ship_address = current_user.ship_address || Spree::Address.default
    @bill_address = current_user.bill_address || Spree::Address.default
  end


  def init_cc_and_period
    @period = 'year'
    @cc = Spree::CreditCard.new(:month => Date.today.month, 
                                :year => Date.today.year, 
                                :first_name => spree_current_user.firstname, 
                                :last_name => spree_current_user.lastname)
  end
end

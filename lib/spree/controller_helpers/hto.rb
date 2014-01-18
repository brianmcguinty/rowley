module Spree::HtoControllerHelpers
  def self.included(base)
    base.class_eval do
      helper_method :current_hto_order
      alias_method_chain :current_hto_order, :multi_domain
    end
  end

  def current_hto_order(create_order_if_necessary = false)
    return @current_hto_order if @current_hto_order
    if session[:hto_order_id]
      current_hto_order = Spree::Order.find_by_id_and_currency(session[:hto_order_id], current_currency, :include => :adjustments)
      @current_hto_order = current_hto_order unless current_hto_order.try(:completed?)
    end
    if create_order_if_necessary and (@current_hto_order.nil? or @current_hto_order.completed?)
      @current_hto_order = Spree::Order.new(:currency => current_currency, :hto => true)
      before_save_new_hto_order
      @current_hto_order.save!
      after_save_new_hto_order
    end
    if @current_hto_order
      @current_hto_order.last_ip_address = request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
      session[:hto_order_id] = @current_hto_order.id
      return @current_hto_order
    end
  end

  def current_hto_order_with_multi_domain(create_order_if_necessary = false)
    current_hto_order_without_multi_domain(create_order_if_necessary)

    if @current_hto_order and current_store and @current_hto_order.store.nil?
      @current_hto_order.update_attribute(:store_id, current_store.id)
    end

    @current_hto_order
  end


  def set_current_order
    if user = try_spree_current_user
      # normal order
      last_incomplete_normal_order = user.last_incomplete_normal_order
      if session[:order_id].nil? && last_incomplete_normal_order
        session[:order_id] = last_incomplete_normal_order.id
      elsif current_order(true) && last_incomplete_normal_order && current_order != last_incomplete_normal_order
        current_order.merge!(last_incomplete_normal_order)
      end
      # hto order
      last_incomplete_hto_order = user.last_incomplete_hto_order
      if session[:hto_order_id].nil? && last_incomplete_hto_order
        session[:hto_order_id] = last_incomplete_hto_order.id
      elsif current_hto_order(true) && last_incomplete_hto_order && current_hto_order != last_incomplete_hto_order
        current_hto_order.merge!(last_incomplete_hto_order)
      end
    end
  end
end

Spree::StoreController.send(:include, Spree::HtoControllerHelpers)
Spree::UsersController.send(:include, Spree::HtoControllerHelpers)
Spree::UserRegistrationsController.send(:include, Spree::HtoControllerHelpers)
Spree::UserSessionsController.send(:include, Spree::HtoControllerHelpers)
Spree::UserPasswordsController.send(:include, Spree::HtoControllerHelpers)

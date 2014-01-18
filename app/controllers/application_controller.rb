class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :assign_to_order
  
  def assign_to_order
    Spree::Order.controller = self
  end
end

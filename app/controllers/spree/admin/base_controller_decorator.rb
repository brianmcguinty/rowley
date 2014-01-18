Spree::Admin::BaseController.class_eval do
  protected
  # def authorize_admin
  #   # binding.pry
  #   authorize! :use_admin_area, :global
  #   authorize! params[:action].to_sym, model_class if model_class.present?
  # end
  def authorize_admin
    fake_object = false
    begin
      record = model_class.new
    rescue
      fake_object = true
      record = Object.new
    end
    unless params[:action].to_sym == :users && fake_object && can?(:manage, Spree::Order)
      authorize! params[:action].to_sym, record
    end
  end
end


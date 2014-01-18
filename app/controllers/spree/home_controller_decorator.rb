Spree::HomeController.class_eval do
  def index
    if current_store.present?
      @products = Spree::Product.active.by_store(current_store.try(:id)).featured.all
    else
      @products = Spree::Product.active.featured.all
    end
    respond_with(@products)
  end
end
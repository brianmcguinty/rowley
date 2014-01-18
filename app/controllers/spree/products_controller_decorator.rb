Spree::ProductsController.class_eval do

  def show_variant
    respond_to do |format|
      format.js
    end
  end

end
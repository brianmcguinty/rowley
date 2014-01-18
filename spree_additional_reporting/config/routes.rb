Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :reports, :only => [] do
      collection do
        get :top_hto_products
        post :top_hto_products
        get :inventory
        get :revenue_by_product
        post :revenue_by_product
        get :revenue_by_product_customers
        post :revenue_by_product_customers
        get :sales
        post :sales
        get :hto_vs_sales
        post :hto_vs_sales
        get :hto_conversion
        post :hto_conversion
      end
    end
  end
end

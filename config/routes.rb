Re::Application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'
          # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'


  scope :module => "spree" do
    match '/products/show_variant/:id' => 'products#show_variant', :as => :show_variant_image
    match '/orders/remove_item/:id' => 'orders#remove_item', :as => :remove_item_from_cart
    match '/checkout/update_shipping_methods' => 'checkout#update_shipping_methods', :as => :update_shipping_methods
    match '/account/update_address' => 'users#update_address', :as => :update_address
    match '/account/purchase_rc' => 'users#purchase_rc', :as => :user_purchase_rc
    match '/account/change_password' => 'users#update', :as => :user_change_password
    match '/account/change_email' => 'users#update', :as => :user_change_email
  end

  resource :rowley_care_subscription, :only => [:show], :module => 'spree' do
    get :cancel
  end

  resources :orders, :module => 'spree' do
    get :as_invoice_email
    get :as_shipping_email
  end

  # resources :users, :module => 'spree' do
  #   post :purchase_rc
  # end
end

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :hto_settings
    resources :products do
      resources :head_turn_images do
        collection do
          post :update_positions
        end
      end
      get :add_product_on_ebay
    end
  end
end

Spree::Core::Engine.routes.prepend do
  match '/hto_checkout/registration' => 'hto_checkout#registration', :via => :get, :as => :hto_checkout_registration
  match '/hto_checkout/registration' => 'hto_checkout#update_registration', :via => :put, :as => :hto_update_checkout_registration
  put '/hto_checkout/update/:state', :to => 'hto_checkout#update', :as => :update_hto_checkout
  get '/hto_checkout/:state', :to => 'hto_checkout#edit', :as => :hto_checkout_state
  get '/hto_checkout', :to => 'hto_checkout#edit' , :as => :hto_checkout
  match '/admin' => 'admin/orders#index', :as => :admin
  match '/admin/dashboard' => 'admin/overview#index', :as => :admin_dashboard
  devise_scope :user do
    get '/cross_login/:site' => 'user_sessions#cross_login', :as => :cross_login
    get '/authenticate_by_cross_login_token' => 'user_sessions#authenticate_by_cross_login_token'
  end
end

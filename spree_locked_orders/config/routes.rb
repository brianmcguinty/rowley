Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :orders do
      get 'unlock' => 'orders#unlock'
    end
  end
end

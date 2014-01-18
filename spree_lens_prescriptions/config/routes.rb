Spree::Core::Engine.routes.draw do
  namespace :admin do
    # resources :orders, :only => [] do
    #   get :prescription
    #   get :prescription
    # end
    resources :orders do
      resource :lens_prescription do
        get :fire
      end
      get 'prescription_to_lab' => 'orders#send_prescription_to_lab', :as => :prescription_to_lab
    end
    resources :users do
      get :cancel_subscription
    end
    resource :lens_prescription_settings
    resource :lens_prescription_uploads_settings
    resource :lens_prescription_lab_email_settings
    resource :subscription_settings
  end

  resource :subscription, :only => [:show], :module => 'lens_prescription' do
    get :cancel
  end
end

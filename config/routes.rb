Rails.application.routes.draw do
  root "v1/home#index"
  devise_for :users

  namespace :v1, path: "/" do
    resources :cars, only: [ :index, :show ], param: :slug do
      collection do
        get :compare
      end
    end
    get "compare", to: "cars#compare", as: :compare_cars

    get "about", to: "about#index"
    get "services", to: "services#index"
  end

  namespace :admin do
    root "dashboard#index"
    resources :cars do
      member do
        patch :toggle_status
        delete :remove_image
      end
    end
    resources :makes do
      get :models, on: :member
    end
    resources :models
    get "models.json", to: "models#models_json"
  end
end

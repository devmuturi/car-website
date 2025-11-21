Rails.application.routes.draw do
  root "v1/home#index"
  devise_for :users, skip: [ :registrations ]

  namespace :v1, path: "/" do
  end
end

Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # get '/profile', to: 'pages#profile', as: :profile
  resources :profile
  resources :kondos do
    resources :bookings, :except => [:index]
  end

  get "/bookings", to: "bookings#index"
end

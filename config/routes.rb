Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # get '/profile', to: 'pages#profile', as: :profile
  resources :profiles, :except => [:index, :destroy]
  resources :kondos do
    resources :bookings, :except => [:index] do
      resources :reviews, :only => [:create]
    end
  end

  get "/bookings", to: "bookings#index"
end

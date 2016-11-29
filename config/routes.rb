Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "recipes#index", as: :authenticated_root
  end

  root "pages#home"
  resources :recipes do
    member do
      post "toggle_pin", to: "recipes#toggle_pin"
    end
  end
  resources :tags
  resources :categories

  match "/invite/:invite_token", via: [:get, :post], to: "invite#show", as: "invite"
end

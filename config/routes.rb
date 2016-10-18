Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root to: "recipes#index", as: :authenticated_root
  end


  root "pages#home"
  resources :recipes, path: "/"
end

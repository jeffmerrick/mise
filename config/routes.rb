Rails.application.routes.draw do
  devise_for :users
  root to: "recipes#index"
  resources :recipes, path: "/"
end

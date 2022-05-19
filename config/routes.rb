Rails.application.routes.draw do

  get 'shopify_auth/login'
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

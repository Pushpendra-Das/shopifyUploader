Rails.application.routes.draw do

  get 'shopify_auth/login'
  resources :products

  # get 'product/index'
  # get 'product/show'
  # get 'product/new'
  # get 'product/create'
  # get 'product/edit'
  # get 'product/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

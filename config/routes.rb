Rails.application.routes.draw do
  root  'words#index'
  get   'fabs/api/' => 'fabs#api'

  resources :fabs
  resources :words
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

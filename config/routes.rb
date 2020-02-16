Rails.application.routes.draw do
  root  'words#index'
  post  'users/login' => 'users#login'
  get   'fabs/api/' => 'fabs#api'

  post  'users/sign_in' => 'users#sign_in'

  resources :fabs
  resources :words
  resources :users#, only: [ :create ] do
  #  collection do
  #    post 'sign_in'
  #  end
  #end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

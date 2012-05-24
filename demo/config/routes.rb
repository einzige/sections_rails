Demo::Application.routes.draw do
  resources :demos, only: [:index]
  root :to => 'demos#index'
end

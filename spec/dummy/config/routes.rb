Dummy::Application.routes.draw do
  resources :tests, only: [] do
    get :one
  end
end


Rails.application.routes.draw do
  root 'questions#index'

  resources :questions, except: [:destroy] do
    get :delete, on: :member
  end
end

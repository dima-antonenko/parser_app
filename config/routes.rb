Rails.application.routes.draw do
  root 'questions#test'

  get '/qa/wededit/all', to: 'questions#index'

  resources :questions, except: [:destroy] do
    get :delete, on: :member
  end
end

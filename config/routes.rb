Rails.application.routes.draw do
  root 'questions#test'

  get '/QA/wededit/all', to: 'questions#index'

  resources :questions, except: [:destroy] do
    get :delete, on: :member
  end
end

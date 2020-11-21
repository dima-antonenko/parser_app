Rails.application.routes.draw do
  root 'questions#test'

  get '/qa/wededit/all', to: 'questions#index', as: 'home'
  get '/qa/wededit/clear', to: 'questions#clear', as: 'clear'

  resources :questions, except: [:destroy] do
    get :delete, on: :member
  end
end

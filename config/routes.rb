Rails.application.routes.draw do
  root 'questions#test'

  get '/qa/wededit/all', to: 'questions#index', as: 'home'
  get '/qa/wededit/clear', to: 'questions#clear', as: 'clear'

  get '/qa/wededit/b_all', to: 'b_questions#index', as: 'b_home'
  get '/qa/wededit/b_clear', to: 'b_questions#clear', as: 'b_clear'

  resources :questions, except: [:destroy] do
    get :delete, on: :member
  end

  resources :b_questions, except: [:destroy] do
    get :delete, on: :member
  end
end

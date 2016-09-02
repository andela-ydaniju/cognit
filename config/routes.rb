Rails.application.routes.draw do
  root 'landing#index'

  get '/auth/token/callback', to: 'sessions#create'
end

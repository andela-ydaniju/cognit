Rails.application.routes.draw do
  root 'landing#index'

  get '/auth/token/callback', to: 'sessions#create'
  get '/insights', to: 'landing#show', as: :personality_insights
  post '/process_insights', to: 'sessions#process_insights'
end

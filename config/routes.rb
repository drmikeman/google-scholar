Rails.application.routes.draw do
  post '/result', to: 'papers#index'
  root 'papers#search'
end

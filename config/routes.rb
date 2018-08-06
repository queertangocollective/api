Rails.application.routes.draw do
  jsonapi_resources :authorizations
  jsonapi_resources :builds
  jsonapi_resources :channels
  jsonapi_resources :events
  jsonapi_resources :groups
  jsonapi_resources :guests
  jsonapi_resources :locations
  jsonapi_resources :people
  jsonapi_resources :photos
  jsonapi_resources :posts
  jsonapi_resources :public_keys
  jsonapi_resources :ticket_stubs
  jsonapi_resources :ticketed_events
  jsonapi_resources :tickets
  jsonapi_resources :transactions
  jsonapi_resources :venues

  resources :payments, only: [:create]
  resources :pages, only: [:index]
  resources :authorization_sessions, except: [:show]
  get 's3-direct', to: 's3_direct#get'

  match '/health', via: :all, to: 'application#health_check'
  match '/404', via: :all, to: 'application#not_found'
  match '/500', via: :all, to: 'application#internal_server_error'
  match '*any', via: :all, to: 'application#not_found'
end

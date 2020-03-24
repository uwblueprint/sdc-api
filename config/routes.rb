# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    resources :flowcharts do
      resources :flowchart_nodes
    end
  end
  # devise_for :users,
  #            path: '',
  #            path_names: {
  #              sign_in: 'login',
  #              sign_out: 'logout'
  #            },
  #            controllers: {
  #              sessions: 'sessions'
  #            },
  #            defaults: { format: :json }
  get 'flowchart_icon_helper/new'
  get 'flowchart_icon/new'
  get '/questions', to: 'questions#index'

  get '/flowchart/:id', to: 'flowchart#serialized_flowchart_by_id'
  get '/flowcharts', to: 'flowchart#all_flowcharts'
  post '/flowchart', to: 'flowchart#create'
  put '/flowchart/:id', to: 'flowchart#update'
  delete '/flowchart/:id', to: 'flowchart#delete'

  get '/flowchart_node/:id', to: 'flowchart_node#show'
  get '/flowchart_node/:id/parent', to: 'flowchart_node#parent'
  get '/flowchart_node/:id/parents', to: 'flowchart_node#parents'
  get '/flowchart_node/:id/children', to: 'flowchart_node#children'
  post '/flowchart_node', to: 'flowchart_node#create'
  put '/flowchart_node/swap', to: 'flowchart_node#swap'
  put '/flowchart_node/:id', to: 'flowchart_node#update'
  delete '/flowchart_node/:id', to: 'flowchart_node#delete'
end

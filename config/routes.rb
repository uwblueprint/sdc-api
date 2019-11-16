# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get '/questions', to: 'questions#index'

  get '/flowchart/:id', to: 'flowchart#serialized_flowchart_by_id'
  get '/flowcharts', to: 'flowchart#all_flowcharts'
  post '/flowchart', to: 'flowchart#create'
  put '/flowchart/:id', to: 'flowchart#update'
  delete '/flowchart/:id', to: 'flowchart#delete'

  get '/flowchart_node/:id', to: 'flowchart_node#show'
  post '/flowchart_node/:id', to: 'flowchart_node#create'
  put '/flowchart_node/swap', to: 'flowchart_node#swap'
  put '/flowchart_node/:id', to: 'flowchart_node#update'
  delete '/flowchart_node/:id', to: 'flowchart_node#delete'
end


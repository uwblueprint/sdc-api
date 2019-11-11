# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get '/questions', to: 'questions#index'

  get '/flowchart_node/:id', to: 'flowchart_node#show'
  put '/flowchart_node/swap', to: 'flowchart_node#swap'
  put '/flowchart_node/:id', to: 'flowchart_node#update'
  delete '/flowchart_node/:id', to: 'flowchart_node#delete'
end

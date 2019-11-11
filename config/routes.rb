# frozen_string_literal: true

Rails.application.routes.draw do
  get '/questions', to: 'questions#index'
  get '/flowchart/:id', to: 'flowchart#serialized_flowchart_by_id'
  get '/flowcharts', to: 'flowchart#all_flowcharts'
  post '/flowchart', to: 'flowchart#create'
  put '/flowchart/:id', to: 'flowchart#update'
  delete '/flowchart/:id', to: 'flowchart#delete'
end

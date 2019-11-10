# frozen_string_literal: true

Rails.application.routes.draw do
  get '/questions', to: 'questions#index'
  get '/flowcharts/:id', to: 'flowchart#get_by_id'
end

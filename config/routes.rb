# frozen_string_literal: true

Rails.application.routes.draw do
  get '/questions', to: 'questions#index'
  get '/flowcharts/:id', to: 'flowchart#serialized_flowchart_by_id'
end

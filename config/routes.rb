# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get '/questions', to: 'questions#index'
end

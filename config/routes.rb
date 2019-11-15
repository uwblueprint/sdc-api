# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
              path: '',
              path_names: {
                sign_in: 'login',
                sign_out: 'logout'
              },
              controllers: {
                sessions: 'sessions'
              }
  get '/questions', to: 'questions#index'
end

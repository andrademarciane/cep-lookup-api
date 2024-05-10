# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post '/authentication', to: 'authentication#create'

    get '/addresses/:cep', to: 'addresses#show'
  end
end

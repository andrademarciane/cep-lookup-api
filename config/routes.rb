# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post '/authentication', to: 'authentication#create'

    get '/addresses/:cep', to: 'addresses#show'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
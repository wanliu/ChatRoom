#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

require 'msg_server'

ChatRoom::Application.routes.draw do

  resource :profiles

  devise_for :users, :path => "accounts", :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }


  match "/stream", :to => MessageServer
  root :to => 'home#index'

  resources :rooms do 
    member do
      put 'enter'
      put 'exit'
    end
  end

  match "/users/current_user", :to => "users#get_current_user"
  resources :users 

  mount JasmineRails::Engine => "/specs" unless Rails.env.production?

  #the following created by Jzl
  # match "/auth/:provider/callback" => 'sessions#create'
  # match "/signout" => "sessions#destroy", :as => :signout

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

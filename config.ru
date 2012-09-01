# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
# require "msg_server"
# require 'sinatra'
# require 'faye'
# Faye::WebSocket.load_adapter('thin')

# # faye_app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

# app = Rack::Builder.new {
#   run Rack::Cascade.new([faye_app, ChatRoom::Application])
# }.to_app

run ChatRoom::Application

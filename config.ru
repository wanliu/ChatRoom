# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require "msg_server"
# require 'sinatra'

app = Rack::Builder.new {
#  use Rails::Rack::Static
  run Rack::Cascade.new([MessageServer, ChatRoom::Application])
}.to_app

run app

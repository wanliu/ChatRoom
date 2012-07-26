# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require "streamserver"
# require 'sinatra'

app = Rack::Builder.new {
#  use Rails::Rack::Static
  run Rack::Cascade.new([StreamServer, ChatRoom::Application])
}.to_app

run app

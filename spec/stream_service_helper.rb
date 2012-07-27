require 'rspec'
require 'rack/test'
require "msg_server"

set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  MessageServer
end
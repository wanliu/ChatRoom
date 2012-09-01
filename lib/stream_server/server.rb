# encoding : utf-8
# Copyright (C) 2012 Hysios Hu  <hysios@gmail.com>
require 'sinatra'
require 'thin'

module StreamServer
  class Server < Sinatra::Base
    # include Session
    set server: 'thin'

    get '/stream', provides: 'text/event-stream' do
      stream :keep_open do |out|
        puts "Establish a connection..."
        p request
        
        conn = dispatcher.add_connection(out, request)
        ActiveRecord::Base.connection.close
        #settings.connections << conn
        out.callback { dispatcher.remove_connection(conn) }
        out.errback { dispatcher.remove_connection(conn) }
      end
    end

    post '/stream' do
      puts "Relay to #{dispatcher.global_connections.count} streams"
      _request = Request.new(request)
      _request.connections += dispatcher.global_connections
      dispatcher.dispatch(_request)
      ActiveRecord::Base.connection.close
    end


    def dispatcher
      @@dispatcher ||= DispatchGenerator.generate_dispatch
    end

    def self.dispatch(&block)
      DispatchGenerator.load_configuration(&block)
    end
  end
end
require 'sinatra'
require 'thin'

module StreamServer
  class Server < Sinatra::Base
    # include Session
    set server: 'thin'

    get '/stream', provides: 'text/event-stream' do
      stream :keep_open do |out|
        conn = Connection.fetch(out, request)
        dispatcher.connections << conn
        #settings.connections << conn
        out.callback { dispatcher.connections.delete conn }
        out.errback { dispatcher.connections.delete conn }
      end
    end

    post '/stream' do
      puts "Relay to #{dispatcher.connections.count} streams"
      # @request = request
      dispatcher.params = params
      dispatcher.dispatch(request)
      # room = current_user.room
      # unless room.blank?
      #   room_connections(room).each do |conn| 
      #     conn.stream << "data: #{params[:msg]}\n\n" 
      #   end
      # end
      # 204 # response without entity body
    end


    def dispatcher
      @@dispatcher ||= DispatchGenerator.generate_dispatch
    end

    def self.dispatch(&block)
      DispatchGenerator.load_configuration(&block)
    end
  end
end
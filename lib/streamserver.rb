require 'sinatra'
require 'thin'

class StreamServer < Sinatra::Base
  set server: 'thin'
  set connections: []

  get '/stream', provides: 'text/event-stream' do
    stream :keep_open do |out|
      settings.connections << out
      out.callback { settings.connections.delete(out) }
      out.errback { settings.connections.delete out }
    end
  end

  post '/stream' do
    puts "Relay to #{settings.connections.count} streams"
    settings.connections.each { |out| out << "data: #{params[:msg]}\n\n" }
    204 # response without entity body
  end
end
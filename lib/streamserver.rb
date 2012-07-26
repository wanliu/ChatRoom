require 'sinatra'
require 'thin'

class StreamServer < Sinatra::Base
  set server: 'thin'
  set connections: []

  get '/stream', provides: 'text/event-stream' do
    stream :keep_open do |out|
      conn = OpenStruct.new(:stream => out, :session_id => request.cookies.values[0])
      settings.connections << conn
      out.callback { settings.connections.delete(conn) }
      out.errback { settings.connections.delete conn }
    end
  end

  post '/stream' do
    puts "Relay to #{settings.connections.count} streams"

    settings.connections.each do |conn| 
      conn.stream << "data: #{params[:msg]}\n\n" 
    end
    204 # response without entity body
  end

  def session_record(_sessoin_id = request.cookies.values[0])
    ActiveRecord::SessionStore::Session.find_by_session_id(_sessoin_id)
  end  

  def current_user(_session = session)
    user_key = _session["warden.user.user.key"]
    Warden::SessionSerializer.new(User).deserialize(user_key)
  end

  def session(_sesison_record = session_record)
    _sesison_record.data
  end

end
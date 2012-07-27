require 'sinatra'
require 'thin'

class StreamServer < Sinatra::Base
  set server: 'thin'
  set connections: []

  get '/stream', provides: 'text/event-stream' do
    stream :keep_open do |out|
      rs = RevertSession.new(request)
      conn = OpenStruct.new(:stream => out, :session_id => request.cookies.values[0], :user => rs.current_user)
      settings.connections << conn
      out.callback { settings.connections.delete(conn) }
      out.errback { settings.connections.delete conn }
    end
  end

  post '/stream' do
    puts "Relay to #{settings.connections.count} streams"
    rs = RevertSession.new(request)
    room = Room.at(rs.current_user)
    unless room.blank?
      room_connections(room).each do |conn| 
        conn.stream << "data: #{params[:msg]}\n\n" 
      end
    end
    204 # response without entity body
  end

  def room_connections(room)
    settings.connections.select { |conn| conn.user.room == room }
  end


end

class RevertSession
  def initialize(request)
    @request = request
  end

  def session_id
    @request.cookies[Rails.application.config.session_options[:key]]
  end

  def session_record
    ActiveRecord::SessionStore::Session.find_by_session_id(session_id)
  end  

  def session
    session_record && session_record.data
  end

  def current_user
    return nil unless session && user_key = session["warden.user.user.key"]
    Warden::SessionSerializer.new(User).deserialize(user_key)
  end

end
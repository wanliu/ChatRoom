module StreamServer
  module Dispatcher
    class RoomDispatcher < Base
      def dispatch(request)
        @request = request
        
        room = ActiveRecord::Base.silence { @request.current_user.rooms.where("rooms.id = ?", params[:room_id]).first }
        # room = @request.current_user.room
        puts "Room" if Rails.env.development?
        if !room.nil?
          room_connections(room).each do |conn| 
            conn.stream << room_event_message(room, 'onmessage', params['msg'])
            # conn.stream << message(params['msg']) 
          end
        else
          puts params['msg'], current_stream
          # current_stream << room_event_message(room, 'onmessage', params['msg'])
          current_stream << message(params['msg'])
        end
        super
      end

      def room_connections(room)

        connections.flatten.select { |conn| conn.user_room == room }
      end      
    end
  end
end
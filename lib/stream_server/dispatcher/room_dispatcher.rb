module StreamServer
  module Dispatcher
    class RoomDispatcher < Base
      def dispatch(request)
        @request = request
        room = ActiveRecord::Base.silence { current_user.room }
        unless room.blank?
          room_connections(room).each do |conn| 
            conn.stream << "data: #{params['msg']}\n\n" 
          end
        end
        super
      end

      def room_connections(room)

        connections.select { |conn| conn.user_room == room }
      end      
    end
  end
end
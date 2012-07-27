module StreamServer
  module Dispatcher
    class Base
      include Session

      attr_accessor :connections, :params, :handler

      def connections 
        @connections ||= []
      end

      def dispatch(request)
        @request = request

        room = current_user.room
        unless room.blank?
          room_connections(room).each do |conn| 
            conn.stream << "data: #{params[:msg]}\n\n" 
          end
        end
        204 # response without entity body
      end

      def room_connections(room)
        connections.select { |conn| conn.user.room == room }
      end
    end 
  end
end

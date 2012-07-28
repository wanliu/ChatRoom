module StreamServer
  module Dispatcher
    class Base
      include Session

      cattr_accessor :global_connections
      @@global_connections = []

      attr_accessor :connections, :handler

      def initialize

        yield(self) if block_given?
      end
  
      def add_connection(stream, request)
        global_connections << Connection.fetch(stream, request)
      end

      def global_connections 
        @@global_connections
      end

      def remove_connection(conn)
        global_connections.delete(conn)
      end

      def connections
        (@request && @request.connections) || []
      end

      def dispatch(request)
        @request = request
        handler.dispatch(request) if handler && handler.respond_to?(:dispatch)
        204 # response without entity body
      end

      private 
        def params
          @params = (@request && @request.params) || {}
        end
    end
  end
end

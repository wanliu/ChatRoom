module StreamServer
  class GeneratorArgumentMismatch < ArgumentError ; end
  # Generater a dispatcher DSL
  # Examples 
  #  class MessageServer < StreamServer::Server
  #     dispatch do 
  #       use :command
  #       use "RoomDispatcher"
  #       use ::StreamServer::Dispatcher::CommandDispatcher
  #     end
  #  end
  class DispatchGenerator
    cattr_reader :dispatchers
    @@dispatchers = []

    class << self

      def load_configuration(&block)
        self.new.instance_eval(&block)
      end

      def generate_dispatch
        first_klass = @@dispatchers.pop.new
        @@dispatchers.reverse.inject(first_klass) do |dispatcher, klass|
          klass.new { |k| k.handler = dispatcher }
        end
      end
    end


    def use(klass)
      case klass
      when Class
        @@dispatchers << klass
      when Symbol
        klass_string = "::StreamServer::Dispatcher::#{klass.to_s.classify}Dispatcher"
        @@dispatchers << klass_string.constantize
      when String
        @@dispatchers << klass.constantize
      else
        raise GeneratorArgumentMismatch.new("klass is only Class, String, Symbol")
      end
    end
  end
end

module StreamServer
  class Request < DelegateClass(Sinatra::Request)

    attr_accessor :connections

    def initialize(request)
      #  self.class.__send__(:include, request)
      @request = request
      @connections  = []
      super
    end

  end
end
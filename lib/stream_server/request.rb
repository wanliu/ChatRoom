module StreamServer
  class Request < DelegateClass(Sinatra::Request)
    include Session

    attr_accessor :connections

    def initialize(request)
      #  self.class.__send__(:include, request)
      @request = request
      @connections  = []
      super
    end

  end
end
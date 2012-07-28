module StreamServer
  class Connection
    include Session    
    attr_reader :stream, :request

    alias_method :user, :current_user
    
    def self.fetch(stream, request)
      new(stream, request)
    end

    def initialize(stream, request)
      @stream = stream
      @request = request.dup
    end

    def user_room
      ActiveRecord::Base.silence { user.room }
    end
  end
end
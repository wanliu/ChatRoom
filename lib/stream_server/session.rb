module StreamServer
  module Session

    def session
      session_record && session_record.data
    end

    def current_user
      return nil unless session && user_key = session["warden.user.user.key"]
      Warden::SessionSerializer.new(User).deserialize(user_key)
    end

    private 

    def session_id
      @request.cookies[Rails.application.config.session_options[:key]]
    end

    def session_record
      ActiveRecord::SessionStore::Session.find_by_session_id(session_id)
    end
  end
end

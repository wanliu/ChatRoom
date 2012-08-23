module StreamServer
  module Session
    class DeviseAdapter
      def initialize(request)
        @request = request
      end

      def session
        session_record && session_record.data
      end

      def session_key
        session["warden.user.user.key"]
      end

      def uniq_key_name
        session_key[1..2].join()
      end

      def current_user
        return nil unless session && user_key = session_key
        Rails.cache.fetch "user_#{uniq_key_name}", :expires_in => 5.minutes do 
          Warden::SessionSerializer.new(User).deserialize(user_key)
        end
      end
      private 
        def session_id
          @request.cookies[Rails.application.config.session_options[:key]]
        end

        def session_record
          Rails.cache.fetch "session_record_#{session_id}" , :expires_in => 5.minutes do 
            ActiveRecord::SessionStore::Session.find_by_session_id(session_id)
          end
        end
    end
  end
end

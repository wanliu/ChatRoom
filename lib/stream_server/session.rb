module StreamServer
  module Session

    def session
      session_adapter.session
    end

    def current_user
      session_adapter.current_user
    end

    def session_adapter
      @session_adapter ||= DeviseAdapter.new(@request)
    end
    private

      def session_id
        session_adapter.session_id
      end

      def session_record
        session_adapter.session_record
      end
  end
end

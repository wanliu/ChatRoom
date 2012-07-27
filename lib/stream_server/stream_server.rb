module StreamServer
  autoload :Connection        ,  'stream_server/connection'
  autoload :Session           ,  'stream_server/session'
  autoload :DispatchGenerator ,  'stream_server/dispatch_generator'
  autoload :Server            ,  'stream_server/server'

  module Dispatcher
    autoload :Base              ,'stream_server/dispatcher/base'
    autoload :CommandDispatcher ,'stream_server/dispatcher/command_dispatcher'
    autoload :RoomDispatcher    ,'stream_server/dispatcher/room_dispatcher'
  end
end

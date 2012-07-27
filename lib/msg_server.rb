require 'stream_server/stream_server'

class MessageServer < StreamServer::Server

  dispatch do 
    use :command
    use :room
  end
end
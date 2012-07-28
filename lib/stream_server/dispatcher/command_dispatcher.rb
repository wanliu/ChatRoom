# encoding : utf-8
# require File.expand_path("../command", __FILE__)

module StreamServer
  module Dispatcher
    class CommandDispatcher < Base

      COMMAND = /^\/(\w+)/i
      COMMAND_LIST = /^\/join\s(\w+)/i

      def dispatch(request)
        @request = request
        super unless parse(params['msg'])
        204
      end

      def parse(msg)
        if msg =~ COMMAND
          command = $1.downcase
          puts "COMMAND:#{command}"
          case command
          when "help"
#            debugger
#            current_stream << message(usage)
            output(usage)
          when "list"
            room_names = Room.all.collect {|room| room.name }
            current_stream << message(room_names)
          when "join"
            room_name = $'.strip
            if !current_user.join(room_name)
              current_stream << message("failed can't join name #{room_name} of room")
            else
              current_stream << message("OK")
            end
          when "leave"
            current_user.leave
          when "at"
            current_stream << message(current_user.room.name)
          when "members"
            users = current_user.room.members.collect { |m| m.email }
            current_stream << message(users)
          else
            current_stream << message('error command')
          end
          true
        else
          false
        end
      end

      def output(msg)
        current_stream << "data:\n"

        msg.split('\n').each { | line| puts line; current_stream << line }
      end

      def usage
#        "帮助\n/help           : 显示此命令帮助\n/list           : 显示全部方间\n/join Room Name : 进入 Room Name 房间\n/leave          : 离开当前的房间\n/at             : 显示所在房间\n/members        : 显示房间中所有成员\n"
        """usage asdfasdf asd
          falsesdf
          asdfasdfas
          defasd
"""
      end
    end
  end
end
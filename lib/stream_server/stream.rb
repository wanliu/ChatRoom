module StreamServer

  class Stream
    def initialize(stream)
      @stream = stream
    end

    def << data
      # data = data.to_s
      # datas = data.split("\n")
      # if datas.length > 1
      #   output = ""
      #   if event?(datas.first)
      #     event, name = event(datas.shift) 
      #     output << ln("event:" + name)
      #   end

      #   #_author , first_line = author(datas.shift)
      #   #datas.unshift(first_line)
      #   #output << ln(_author)
      #   datas.each do |line|
      #     output << ln("data: #{line}")
      #   end
      #   output << "\n"
      #   puts output
      #   @stream << output

      # else
      #   @stream << "data: #{data}\n\n" 
      # end
      @stream << data
    end

    def ln(data)
      "#{data}\n"
    end

    def author(data)
      data, _author, first_line = data.split(":")
      [data + ':' + _author + ':', first_line.strip]
    end

    def event(data)
      event, name = data.split(":")
    end

    def event?(data)
      event, name = data.split(":")
      event == "event"
    end
  end
end

module StreamServer

  class Stream
    def initialize(stream)
      @stream = stream
    end

    def << data
      data = data.to_s
      datas = data.split("\n")
      if datas.length > 1
        _author , first_line = author(datas.shift)
        datas.unshift(first_line)
        @stream << _author + "\n\n"
        datas.each do |line|
          @stream << "data: #{line}\n\n" 
        end
      else
        @stream << data
      end
    end

    def author(data)
      data, _author, first_line = data.split(":")
      [data + ':' + _author + ':', first_line.strip]
    end
  end
end

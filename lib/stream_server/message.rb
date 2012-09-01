module StreamServer
  # mesasge = Message.new
  # message
  #   .event("chat")
  #   .author("hysios@gmail.com")
  #   .data("hi")
  class Message

    JSON_HASH = /^\{(.*?)\}$/m

    def initialize
      @string_queue = []
    end

    def id(int)
      @string_queue << "id: #{int}"
      self
    end

    def event(name)
      @string_queue << "event: #{name}"
      self
    end

    def author(name)
      @string_queue << "author: #{name}"
      self
    end

    def data(msg)
      if msg.is_a?(Hash) 
        strings = msg.to_json.split("\n")
      else
        strings = msg.split("\n")
      end
      strings.each do |line|
        @string_queue << "data: #{line}"
      end
      self
    end

    def convert_json_string(data)
      if m = JSON_HASH.match(data.to_json)
        strings = m[1].split("\n")
        strings = strings.unshift("{").push("}")
      else
        ["{", "}"]
      end

    end

    def to_s
      @string_queue.join("\n") + "\n\n"
    end


  end
end
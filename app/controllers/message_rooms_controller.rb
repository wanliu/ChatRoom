class MessageRoomsController < FayeRails::Controller
  channel '/**' do
    monitor :subscribe do
      debugger
      puts "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      puts "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      puts "Client #{client_id} published #{data.inspect} to #{channel}."
    end   
  end

end
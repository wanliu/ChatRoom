require File.expand_path("../../stream_service_helper", __FILE__)


describe "stream server" do
  
  it "subscribe /stream" do
    get "/stream", {}, "accept" => 'text/event-stream'
    puts last_response.body
  end
end

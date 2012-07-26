class ChatController < Cramp::Action
	on_start :send_hello

	def send_hello
		render "Hello World"
		finish
	end
end
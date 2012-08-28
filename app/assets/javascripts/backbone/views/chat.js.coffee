namespace "ChatRoom", (ex) ->

	class ex.ChatView extends ChatRoom.MessageView

		msg_target: "#msg"
		bottom_target: ".input-text"

		template: ChatRoom.template("home/chat")

		events: {
			"submit .input-text": "sendChat"
		}

		message: {
			"onmessage": "onmessage"
		}

		initialize: (options) ->
			_.extend(@, options)
			@registerListener(@model)

		onmessage: (event) ->
			console.log event.data

		sendChat: () ->

			msg = @$msg.val()
			@sendMessage(msg)
			@$msg.val("")
			false


		render: () ->
			$(@el).html(@template())
			@$chat = @$("#chat")
			@$msg  = @$("#msg")
			$(window).resize($.proxy(@resize,@))
			@resize()

		resize:(event) ->

			max_height = $(window).height()

			padding_hegiht = parseInt(@$chat.css('padding-top')) +
				parseInt(@$chat.css('padding-bottom')) + 
				parseInt(@$chat.css('border-bottom-width'))	+ 
				parseInt(@$chat.css('border-top-width'))

			bottom_height = $(@bottom_target).outerHeight(true) 

			p1 = @$chat.offset()

			@$chat.height(max_height - bottom_height - padding_hegiht - p1.top - 10)

namespace "ChatRoom", (ex) ->

	class ex.ChatView extends ChatRoom.MessageView

		msg_target: "#msg"
		bottom_target: ".input-text"

		template: ChatRoom.template("home/chat")

		events: {
			"submit .input-text": "sendChat"
			"keydown #msg": "ctrlEnter"
		}

		messages: {
			"chat": "chat"
		}

		initialize: (options) ->
			_.extend(@, options)
			@registerListener("rooms/#{@model.id}")

		render: () ->
			$(@el).html(@template())
			@$chat = @$("#chat")
			@$msg  = @$("#msg")
			$(window).resize($.proxy(@resize,@))
			setTimeout($.proxy(@resize, @) , 10)

		chat: (result) ->
		
			@$chat.append("<p><span class=\"author\">#{result.author}:</span><span>#{result.msg}</span><p>")
			max = @$chat[0].scrollHeight - @$chat.height()
			@$chat.scrollTop(max)

		sendChat: () ->

			msg = @$msg.val()
			msg_hash = {
				'msg'     : msg
				'author' : Home.current_user.get("name")
			}

			publication = @sendObject(@eventPath("chat"), msg_hash)

			publication.callback () ->
				console.log 'Message received by server!'

			publication.errback (error) ->
				console.log 'There was a problem: ' + error.message

			@$msg.val("")
			false

		ctrlEnter: (event) ->
			if (event.keyCode == 10 || event.keyCode == 13 && event.ctrlKey)
		    	@sendChat()

		resize:(event) ->

			max_height = $(window).height()

			padding_hegiht = parseInt(@$chat.css('padding-top')) +
				parseInt(@$chat.css('padding-bottom')) + 
				parseInt(@$chat.css('border-bottom-width'))	+ 
				parseInt(@$chat.css('border-top-width'))

			bottom_height = $(@bottom_target).outerHeight(true) 

			p1 = @$chat.offset()
			@$chat.animate({
				height:　max_height - bottom_height - padding_hegiht - p1.top - 30
				})
			#　@$chat.height()

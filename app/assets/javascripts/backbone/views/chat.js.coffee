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
			@members = new ex.RoomUsers(room : @model)
			@members.fetch()

			@registerListener("room_#{@model.id}")

		render: () ->
			$(@el).html(@template())
			@$chat = @$("#chat")
			@$msg  = @$("#msg")
			$(window).resize($.proxy(@resize,@))
			setTimeout($.proxy(@resize, @) , 10)

		chat: (event) ->
		
			result = JSON.parse(event.data)
			author = @getMemberUser(result.author)
			author_img = image_tag(author.gravatar(s: 20))
			@$chat.append("<p>#{author_img}<span class=\"author\">#{result.author}:</span><span>#{result.msg}</span><p>")
			max = @$chat[0].scrollHeight - @$chat.height()
			@$chat.scrollTop(max)

		getMemberUser: (name) ->
			user = @members.find (user) ->
				user.get("name") == name
		
			unless user?
				@members.fetchUserName(name)
				@members.first() || new ex.User
			user


		sendChat: () ->

			msg = @$msg.val()
			msg_hash = {
				'msg'     : msg
				'room_id' : @model.get("id")
			}
			@sendObject(msg_hash)

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

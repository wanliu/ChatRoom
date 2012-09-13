namespace "ChatRoom", (ex) ->

	class ex.Message
		time : 1
		defaultTitle : document.title
		timer : null

		show: ()->
			@time++
			if @time%2 == 0
				document.title = "【新消息】"
			else
				document.title = "【　　　】"
			document.title += @defaultTitle
			if  !@timer
				@timer = self.setInterval($.proxy(@show, @) , 600)

		clear: ()->
			window.clearInterval(@timer)
			@timer = null
			document.title = @defaultTitle

	class ex.ChatView extends ChatRoom.MessageView

		msg_target: "#msg"
		bottom_target: ".input-text"

		template: ChatRoom.template("home/chat")

		events: {
			"submit .input-text": "sendChat"
			"keydown #msg"		: "ctrlEnter"
			"click .quitRoom"	: "quitRoom"
			"click #showEmoticons" : "showEmoticons"
			"click #emoticons>img" : "hideEmoticons"
		}

		showEmoticons: () ->
			$(".tab-pane.active").find("#emoticons").toggle()

		hideEmoticons: (event) ->
			$(".tab-pane.active").find("#msg").append("<img src='#{event.currentTarget.src}'>")
			$(".tab-pane.active").find("#emoticons").hide()

		messages: {
			"chat": "chat"
		}

		initialize: (options) ->
			@checkNotifictionsSupport()
			_.extend(@, options)
			@registerListener("rooms/#{@model.id}")
			@members = new ex.RoomUsers(room : @model)
			@members.fetch()

			@message = new ex.Message()
			$("body").click($.proxy(@restoreTitle, @))

		checkNotifictionsSupport: () ->
			if window.webkitNotifications 
				console.log "浏览器支持Notifications！"
			else
				console.log "浏览器不支持Notifications！"

		restoreTitle: () ->
			@message.clear()

		render: () ->
			$(@el).html(@template())
			@$chat = @$("#chat")
			@$msg  = @$("#msg")
			$(window).resize($.proxy(@resize,@))
			setTimeout($.proxy(@resize, @) , 10)

		chat: (result) ->
			author = @getMemberUser(result.author)
			author_img = image_tag(author.gravatar(s: 20))
			@$chat.append("<p>#{author_img}<span class=\"author\">&nbsp;#{result.author}:</span><span>#{result.msg}</span><p>")
			max = @$chat[0].scrollHeight - @$chat.height()
			@$chat.scrollTop(max)
			@showMessageNotifiction()

		showMessageNotifiction: () ->
			if (!document.hasFocus()) && (author.attributes.name != Home.current_user.get("name"))
				if window.webkitNotifications.checkPermission() == 0 
					notification = window.webkitNotifications.createNotification(author.gravatar_url(), result.author, result.msg)
					notification.ondisplay = ()->  
						# console.log("display")
					notification.onclose = ()-> 
						# console.log("close")

					notification.show()
					setTimeout((-> notification.cancel()), 4000)
				else
					window.webkitNotifications.requestPermission()
				@message.show()

		getMemberUser: (name) ->
			user = @members.find (user) -> 
				user.get("name") == name
			
			user = if !user?
				@members.fetchUserName(name)
				@members.first() || new ex.User
			else
				user
			

		sendChat: () ->

			msg = @$msg.html()
			msg_hash = {
				'msg'     : msg
				'author' : Home.current_user.get("name")
			}

			publication = @sendObject(@eventPath("chat"), msg_hash)

			publication.callback () ->
				console.log 'Message received by server!'

			publication.errback (error) ->
				console.log 'There was a problem: ' + error.message

			@$msg.html("")
			false

		ctrlEnter: (event) ->
			if (event.keyCode == 10 || event.keyCode == 13 && event.ctrlKey)
				@sendChat()

		quitRoom: () ->			
			@model.exit () =>
				if @multi_tabs? && _.isObject(@multi_tabs) && _.isFunction(@multi_tabs.removePane)
					@multi_tabs.removePane(@)

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


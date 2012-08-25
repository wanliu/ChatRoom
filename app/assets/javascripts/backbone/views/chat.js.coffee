namespace "ChatRoom", (ex) ->

	class ex.MsgChatView extends Backbone.View

		template: ChatRoom.template("chats/chat")

		render: () ->
			$(@el).html(@template())

		with_user: (user_name) ->
			@$(".user_name").text(user_name)

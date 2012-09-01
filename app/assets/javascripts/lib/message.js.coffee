
namespace "ChatRoom", (ex) ->

	class ex.MessageView extends Backbone.View

		# room : Room Model
		registerListener: (@scope) ->
			for _event, handle of @messages
				name = "/#{@scope}/#{_event}"
				# name = _event
				MessageService.registerMessage(name, $.proxy(@[handle], @))

		sendObject: (url, hash) ->
			MessageService.sendObject(url, hash)

		eventPath: (event) ->
			"/#{@scope}/#{event}"



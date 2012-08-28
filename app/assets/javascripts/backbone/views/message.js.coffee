
namespace "ChatRoom", (ex) ->

	class ex.MessageView extends Backbone.View

		registerListener: (prefix) ->

			for _event, handle of @messages
				name = "#{prefix}_#{_event}"
				MessageService.registerMessage(name, @handle)


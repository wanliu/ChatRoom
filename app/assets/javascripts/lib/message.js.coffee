
namespace "ChatRoom", (ex) ->

	class ex.MessageView extends Backbone.View

		# room : Room Model
		registerListener: (room) ->
			@room_id ||= room.get("id")
			for _event, handle of @messages
				name = "room_#{@room_id}_#{_event}"
				MessageService.registerMessage(name, $.proxy(@[handle], @))

		sendMessage: (msg) ->
			msg_hash = {
				'msg'     : msg
				'room_id' : @room_id
			}
			
			MessageService.sendObject(msg_hash)


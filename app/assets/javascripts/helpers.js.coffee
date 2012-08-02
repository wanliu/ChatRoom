

namespace "ChatRoom.Helper", (ex) ->

	class ex.Base 
		render:(name) ->
			ChatRoom.template(name)()

load_helpers = () ->
	extend(window, ChatRoom.Helper.Base)

!load_helpers()
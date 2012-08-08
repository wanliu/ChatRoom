

namespace "ChatRoom.Helper", (ex) ->

	class ex.Base 
		render: (name) ->
			ChatRoom.template(name)()

		image_tag: (src, alt = null) ->
			alt ||= src
			"<img src=#{src} alt=#{alt}></img>"


load_helpers = () ->
	extend(window, ChatRoom.Helper.Base)

!load_helpers()
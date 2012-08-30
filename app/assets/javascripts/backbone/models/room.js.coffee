namespace 'ChatRoom', (exports) ->

	class exports.Room extends Backbone.Model
		urlRoot: 'rooms'

		enter: (callback) ->
			@requestRoom(callback, "/enter", "sorry!can't join the room")
			

		exit: (callback) ->
			@requestRoom(callback, "/exit", "sorry!failed to exit")
			

		requestRoom: (callback,target,error) ->
			@save({}, { 
				url : @url() + target , 
				success: (args...) =>
					callback.apply(@)
				error: (args...) =>
					alert(error)
			})
		
	class exports.Rooms extends	Backbone.Collection
		url: 'rooms'
		Model: exports.Room
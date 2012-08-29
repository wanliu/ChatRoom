namespace 'ChatRoom', (exports) ->

	class exports.Room extends Backbone.Model
		urlRoot: 'rooms'

		enter: (callback) ->

			# POST /rooms/1/enter
			@save({}, { 
				url : @url() + "/enter" , 
				success: (args...) =>
					callback.apply(@,args)
				error: (args...) =>
					alert("join the room failed")
			})
		
	class exports.Rooms extends	Backbone.Collection
		url: 'rooms'
		Model: exports.Room
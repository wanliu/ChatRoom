namespace 'ChatRoom', (exports) ->

	class exports.Room extends Backbone.Model
		urlRoot: 'rooms'
		
	class exports.Rooms extends	Backbone.Collection
		url: 'rooms'
		Model: exports.Room
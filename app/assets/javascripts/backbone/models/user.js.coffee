namespace "ChatRoom", (exports) ->
	class exports.User extends Backbone.Model
		urlRoot: "/users"

	class exports.OnlineUser extends exports.User


	class exports.Users extends Backbone.Collection
		url: "/users"
		model: exports.User

	class exports.OnlineUsers extends exports.Users
		model: exports.OnlineUser
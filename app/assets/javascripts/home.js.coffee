# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

namespace "ChatRoom", (exports) ->

	class exports.HomeApplication

		constructor: () ->


		load: ()->
			@home = new exports.HomeView
			@home.render()

			@right_side = new exports.RightSideView
			@right_side.render()

			@chat = new exports.ChatView
			@chat.resize();



		fetch_users: () ->
			@online_users ||= new exports.OnlineUsers


	class exports.HomeView extends Backbone.View
		el: "#layout"
		template: ChatRoom.template("home/index")

		render: () ->
			$(@el).html(@template())


	class exports.OnlineUserButton extends Backbone.View
		tagName: 'li'
		className: 'user'

		render: () ->
			display = "<i class='icon-user' ></i>#{@model.get('email')}"
			$(@el).html(display)
			@


	class exports.RightSideView extends Backbone.View
		el: ".right-side"

		initialize: (options) ->
			_.extend(@, options)
			@users().on("reset", @addAll, @)
			@users().on("add", @addOne, @)
#			@users().on("all", @addAll, @)

			@users().fetch();


		users: () ->
			@_users = window.Home.fetch_users()

		render: ()->

		addOne: (model) ->
			btn = new exports.OnlineUserButton('model': model)
			@$('.online_users').append(btn.render().el);

		addAll: () ->
			@users().each(@addOne)

	class exports.ChatView extends Backbone.View

		el: "#chat"
		msg_target: "#msg"

		initialize: () ->

			$(window).resize($.proxy(@resize,@))


		resize:(event) ->

			p1 = $(@msg_target).offset();
			p2 = $(@el).position()

			$(@el).height(p1.top - p2.top - 20)


	window.Home = new exports.HomeApplication
	window.Home.load();
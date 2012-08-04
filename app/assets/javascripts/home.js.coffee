#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

namespace "ChatRoom", (exports) ->

	class DelayedApplicatonBase
		constructor: () ->
			setTimeout($.proxy(@init, @), 1)

	class exports.HomeApplication extends DelayedApplicatonBase

		init: () ->

			@home = new exports.HomeView
			@home.render()

			@right_side = new exports.RightSideView
			@right_side.render()

			@chat = new exports.ChatView
			@chat.resize();

			ChatRoom.RouterManagement.start();

		fetchView: (name) ->
			@home.lantern

		@fetch_users = () ->
			@online_users ||= new exports.OnlineUsers


	class exports.HomeView extends Backbone.View
		el: "#layout"
		template: ChatRoom.template("home/index")

		render: () ->
			$(@el).html(@template())
			@lantern = new exports.LanternView(@$(".span10"))

	func_remap = { top: 'Y', left: 'X' }

	class exports.OnlineUserButton extends Backbone.View
		tagName: 'li'
		className: 'user'

		events: {
			"click": "doFly"
		}

		render: () ->
			email = @model.get('email')
			email_path = "#profile/#{email}"
			display = "<i class='icon-user' ></i>#{@link_to(email, email_path)}"
			$(@el).html(display)
			@

		coord: (x, y) ->
			{'x': x , 'y': y }

		position_to_coord: (position) ->
			@coord(position.left, position.top)

		readyFly: () ->

			originPos = $(@el).position()

			@fly_el = $("<div />")
				.css({
					'position'  : 'absolute',
					'z-index' 	: '1080',
					'display'   : 'block'
				})
				.appendTo("body")
				.offset(originPos)

			@profile_view = new exports.ProfileView(user: @model.get('email'), el: @fly_el, 'mini': true)
			@profile_view.render()
			[@old_width, @old_height] = @profile_view.getOriginSize()
			console.log @old_width, @old_height

			#@fly_el = $(@el).clone()

			@startPos = @position_to_coord(originPos)

			cp = $(".lantern").position()
			cx = cp.left + @old_width / 2
			cy = cp.top + @old_height / 2

			@target = {
				top: cy, left: cx
			}
			@endPos = @position_to_coord(@target);
			@control1 = @coord(@startPos.x - 50, @startPos.y - 650)
			@control2 = @coord(@endPos.x - 100, @endPos.y - 100)
			@percent = 1		


		doFly: () ->
			@readyFly()

			Backbone.history.navigate("profile/#{@model.get('email')}", {trigger: false, replace: true})
			@fly()
			false


		fly: ()->
			
			return @flyDone() if @percent < 0
			@percent -= 0.01
			pos = ChatRoom.Math.getBezier(@percent, @startPos, @endPos, @control1, @control2)
			width = Math.round(@old_width * (1 - @percent))
			height = Math.round(@old_height * (1 -@percent))
			@fly_el.css({
				'top'         : Math.round(pos.y), 
				'left'        : Math.round(pos.x),
				'width'       : width,
				'height'      : height,
				'margin-top'  : -(height / 2),
				'margin-left' : -(width / 2)
			})

			console.log @old_width

			setTimeout($.proxy(@fly, @),10)

		flyDone: () ->
			window.Home.home.lantern.append(@profile_view)

		link_to: (display, url) ->
			$("<a href=# >#{display}</a>").wrap('<p>').parent().html()


	class exports.RightSideView extends Backbone.View
		el: ".right-side"

		initialize: (options) ->
			_.extend(@, options)
			@users().on("reset", @addAll, @)
			@users().on("add", @addOne, @)
#			@users().on("all", @addAll, @)

			@users().fetch();


		users: () ->
			@_users = exports.HomeApplication.fetch_users()

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

			$(@el).height(p1.top - p2.top - 30)

	class exports.HomeRouter extends Backbone.Router
		routes: {
			"profile/:user_name" :      "profile"
			"help"   			 :	  	"help"
			"hall"				 :		"hall"
		}

		profile: (user_name) ->
			child = window.Home.home.lantern.allocChild()
			view = new exports.ProfileView(user: user_name, el: child)
			view.render()

		help: () ->
			alert("help")

		hall: () ->
			child = window.Home.home.lantern.allocChild()
			view = new exports.GameHallView(el: child)
			view.render()
	

	window.Home = new exports.HomeApplication

	ChatRoom.RouterManagement.register_router(ChatRoom.HomeRouter)


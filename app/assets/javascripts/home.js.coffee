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

	class exports.HomeApplication

		constructor: () ->

			@home = new exports.HomeView
			@home.render()

			@right_side = new exports.RightSideView
			@right_side.render()

			@chat = new exports.ChatView
			@chat.resize();

			ChatRoom.RouterManagement.start();


		@fetch_users = () ->
			@online_users ||= new exports.OnlineUsers


	class exports.HomeView extends Backbone.View
		el: "#layout"
		template: ChatRoom.template("home/index")

		render: () ->
			$(@el).html(@template())


	class EffectContext

		initialize: (@properties) ->

	func_remap = { top: 'Y', left: 'X' }

	class exports.OnlineUserButton extends Backbone.View
		tagName: 'li'
		className: 'user'

		events: {
			"click": "fly"
		}

		render: () ->
			email = @model.get('email')
			email_path = "#profile/#{email}"
			display = "<i class='icon-user' ></i>#{@link_to(email, email_path)}"
			$(@el).html(display)
			@

		coord: (x, y) ->
			{x: x , y: y }

		position_to_coord: (position) ->
			@coord(position.left, position.top)

		fly: ()->
			@fly_el = $(@el).clone()
			
			originPos = $(@el).position()
			@startPos = @position_to_coord(originPos)

			target = {
				top: $(window).height() / 2,
				left: $(window).width() / 2 
			}
			@endPos = @position_to_coord(target);
			@control1 = @coord(@startPos.x, @endPos.x + 200)
			@control2 = @coord(@endPos.y, @endPos.y + 200)
			@percent = {}

			@fly_el.css('position', 'absolute').appendTo("body").offset(originPos)
			@fly_el2 = @fly_el.clone().appendTo("body")
			@fly_el.animate({
				top: $(window).height() / 2,
				left: $(window).width() / 2 
			}, {
	  			duration: 1000, 
				step : (now, fx) =>
					per = @percent[fx.prop] = 1 - now / target[fx.prop];
					xy = @remap_func(fx.prop)(per, @startPos, @endPos ,@control1, @control2 )
					# $(@fly_el).css(fx.prop, Math.round(xy))
					@fly_el2.css(fx.prop, Math.round(xy))
					console.log "percent: #{per}, prop: #{fx.prop}, xy: #{xy}"
					console.log "sPos: #{@startPos.x}, #{@startPos.y} ePos: #{@endPos.x}, #{@endPos.y} "
					console.log "c1: #{@control1.x}, #{@control1.y} c2: #{@control2.x}, #{@control2.y} "
					# fx.pos = xy
					# xy

			})

		remap_func: (prop)->
			func = ChatRoom.Math["getBezier#{func_remap[prop]}"]

		link_to: (display, url) ->
			$("<a href=#{url} >#{display}</a>").wrap('<p>').parent().html()


	class BezierEffect

		initialize: (@element, @startPos, @endPos, @control1, @control2) ->

		calc: (now) ->

		animate: (@properties) ->




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


	window.Home = new exports.HomeApplication

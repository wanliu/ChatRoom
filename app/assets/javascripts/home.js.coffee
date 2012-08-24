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
			@chat.resize()

			@home.attachContainer()

			@current_user = exports.User.current_user()
			# $('.container-view').boxSlider('showSlide', 1);

			ChatRoom.RouterManagement.start();

		getContainer: () ->
			@home.container ||= @home.render().container


		@fetch_users = () ->
			@online_users ||= new exports.OnlineUsers


	class exports.HomeView extends Backbone.View
		el: "#layout"
		template: ChatRoom.template("home/index")

		render: () ->
			$(@el).html(@template())

		attachContainer: () ->
			@container = new Viewport.ContainerView(el: @$(".span10")[0] )
			#@container.setElement(@$(".span10")[0])

			# @lantern = new exports.LanternView(@$(".span10"))

	func_remap = { top: 'Y', left: 'X' }

	class exports.OnlineUserButton extends Backbone.View
		tagName: 'li'
		className: 'user'

		events: {
			#"click": "doFly"
			"click .msg": "msgTo"
		}

		render: () ->
			email = @model.get('email')
			id = @model.get('id')
			nickname = @model.get('nickname')
			gravatar = @model.get('gravatar') + "?s=20"
			email_path = "#profile/#{email}"
			display = "#{image_tag(gravatar, 'gravatar')} #{@link_to(email, email_path)} #{@link_to(nickname, "#", {'class': 'msg', 'id': nickname, 'style': 'color:red'}) }"
			$(@el).html(display)
			@

		coord: (x, y) ->
			{'x': x , 'y': y }

		position_to_coord: (position) ->
			@coord(position.left, position.top)

		msgTo: () ->
			Backbone.history.navigate("msg_to/#{@model.get('email')}", {trigger: true, replace: true})
			false

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

			@container = Home.getContainer().el
			cp = $(@container).position()
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
			window.Home.getContainer.append(@profile_view)

		link_to: (display, url = "#", options = {}) ->
			attributes = (for attr, value of options
				attr + "=" + value
				).join(" ")
			console.log attributes
			$("<a href=#{url} #{attributes}>#{display}</a>").wrap('<p>').parent().html()


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
		bottom_target: ".input-text"

		initialize: () ->

			$(window).resize($.proxy(@resize,@))


		resize:(event) ->

			max_height = $(window).height()

			padding_hegiht = parseInt($(@el).css('padding-top')) +
				parseInt($(@el).css('padding-bottom')) + 
				parseInt($(@el).css('border-bottom-width'))	+ 
				parseInt($(@el).css('border-top-width'))

			bottom_height = $(@bottom_target).outerHeight(true) 

			p1 = $(@el).offset()

			$(@el).height(max_height - bottom_height - padding_hegiht - p1.top - 10)

	class exports.HomeRouter extends Backbone.Router
		routes: {
			"profile/:user_name" :      "profile"
			"msg_to/:user_name"	 : 		"msg_to"
			"home"				 : 		"home"
			"help"   			 :	  	"help"
			"hall"				 :		"hall"
		}

		constructor: ->
			@containerView = Home.getContainer()
			# @profile_view = new exports.ProfileView()
			@containerView.registerView (context) =>
				@hall_view ||= new exports.GameHallView(el: context.el )

			@containerView.registerView "profile", (context, user_name) =>
				@profile_view ||= new exports.ProfileView(user_name: user_name, el: context.el )

			@containerView.registerView "msg_to", (context, user_name) =>
				@msg_view ||= new exports.MsgChatView(el: context.el)


			@containerView.registerEffect (effect)->
				effects = {
					container_el: ">.container-view"
					initialize: (@container_view, @options = {}) ->
						@viewport = $(@container_view.element)
						@container = @viewport.find(@container_el)
						@angle = 0
						@reverse = true
						@isVert = @options.isVert || false

						@enterScene()

					enterScene: () ->
						{top   , left} = @viewport.position()
						[width , height] = [@viewport.width() , @viewport.height()]

						@old_viewport_css  = @saveCss(@viewport)
						@old_container_css = @saveCss(@container)


						vp = {
							position              : 'relative',
							'-webkit-perspective' : '1000px',
							overflow              : 'visible',
							width                 : width,
							height                : height
						}

						@translateZ = if @isVert then  @container.height() / 2 else  @container.width() / 2

						cp = {
							position                  : 'absolute',
							top                       : 0,
							left                      : 0,
							width                     : width,
							height                    : height,
							'-webkit-transform-style' : 'preserve-3d',
							'-webkit-transform'       : "translate3d(0, 0 , -#{@translateZ}px)",
						}

						@viewport.css(vp)
						@container.css(cp)

			
						@sliders = @container.find(">div")
						@sliders.css {
							"position" : "absolute"
							"top"      : 0
							"left"     : 0
							"width"    : width
							"height"   : height
						}
						@sliders.eq(0).css('-webkit-transform', 'rotate3d(0, 1, 0, 0deg) translate3d(0, 0, ' + @translateZ + 'px)')

						@sliders.filter(":gt(0").hide()

						@currentIndex = 0
						@currentSlider = @sliders.eq(@currentIndex)

						setTimeout () => 
							@reset()
						, 10
							
					reset: () ->
						@container.css("-webkit-transition", "-webkit-transform 1s")

					rotate3d: (angle, isVert =  @isVert) ->
						switch angle 
							when 360 , -360 then 'rotate3d(0, 1, 0, 0deg)' # front
							when 90  , -270 then "rotate3d(#{if isVert then '1, 0, 0' else '0, 1, 0'}, -90deg)" # bottom / left side
							when 180 , -180 then "rotate3d(#{if isVert then '1, 0, 0' else '0, 1, 0'}, 180deg)" # back
							when 270 , -90  then "rotate3d(#{if isVert then '1, 0, 0' else '0, 1, 0'}, 90deg)"  # top / right side

					transition: () ->
						nextSlider = @container.find(">div.active")

						currentIndex = @currentSlider.prevAll().length

						@angle += if @reverse then 90 else -90

						if @angle == 0 
							@angle = if @reverse then 360 else -360

						@currentSlider
							.css('z-index', 1)
							.css("opacity", 0)
							.css('-webkit-transition', "opacity 1s")

						@sliders
							.filter (i) => 
								currentIndex != i
							.css("-webkit-transform", "none")
							.css("display", "none")

						nextSlider
							.css("webkit-transform", "#{@rotate3d(@angle)} translate3d(0px, 0px, #{@translateZ}px)")
							.css("display", "block")
							.css("opacity", 1)
#							.css '-webkit-transition', "none"
							.css("z-index", 2)

						@container.css "webkit-transform", "translate3d(0, 0 , -#{@translateZ}px) rotate3d(#{if @isVert then '1,0,0' else '0,1,0'},#{@angle}deg)"

						if Math.abs(@angle) == 360
							@container.css(
								"webkit-transform",
								"translate3d(0,0, -#{@translateZ}px)"
							)

							@angle = 0

						@currentSlider = nextSlider

					revertScene: () ->

						@container
							.removeAttr("style")
							.css(@old_container_css)
						@viewport
							.removeAttr("style")
							.css(@old_viewport_css)					
				}


			super


		profile: (user_name) ->
			@containerView.switchView "profile", user_name, (context) => 
				# context.view = 
				context.view.fetch(user_name)
				context.switch()

		msg_to: (user_name) ->
			@containerView.switchView "msg_to" , user_name, (context) =>
				context.switch()
				context.view.with_user(user_name)

		help: () ->
			alert("help")

		home: () ->
			context = @containerView.first()
			@containerView.switchView(context.view)

		hall: () ->
			@containerView.switchView(@hall_view)


	window.Home = new exports.HomeApplication

	ChatRoom.RouterManagement.register_router(ChatRoom.HomeRouter)


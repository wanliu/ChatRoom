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


			@containerView.registerEffect (effect)->
				effects = {
					container_el: ">.container-view"
					initialize: (@container_view, @options) ->
						@viewport = $(@container_view.element)
						@container = @viewport.find(@container_el)
						@deg = 0

					enterScene: (@old_active) ->
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

						cp = {
							position                  : 'absolute',
							top                       : 0,
							left                      : 0,
							width                     : width,
							height                    : height,
							'-webkit-transform-style' : 'preserve-3d',
							# '-webkit-transform'     : 'translate3d(0px, 0px, 0px) rotate3d(0, 1, 0, 0deg)',
							'-webkit-transition'    : '-webkit-transform 1s'
						}

						@viewport.css(vp)
						@container.css(cp)


					transition: () ->
						active = @container.find(">div.active")

						oldIndex = @old_active.parent().prevAll().length
						Index = active.parent().prevAll().length


						front_css = {
							'position'          : 'absolute',
							'top'               : 0,
							'left'              : 0,
							'-webkit-transform' : 'rotate3d(0, 1, 0, -90deg) translate3d(0px, 0px, 340px)',
							'display'           : 'block',
							'overflow'          : 'visible',
							'z-index'           : 2
						}

						pair_css = {
							'position'          : 'absolute',
							'top'               : 0,
							'left'              : 0,
							'-webkit-transform' : 'rotate3d(0, 1, 0, 0deg) translate3d(0px, 0px, 340px)',
							'display'           : 'block',
							'overflow'          : 'visible'
							'z-index'           : 1
						}

						@deg = if @deg >= 270 then 0 else @deg + 90
						rotate3_str = if @deg == 0 then "" else "rotate3d(0, 1, 0, #{@deg}deg)"
						cont_css = {
							'-webkit-transform'     : "translate3d(0px, 0px, -340px) #{rotate3_str}",
						}

						active.css(front_css)						
						@old_active.css(pair_css)
						@container.css(cont_css)

					transitionFrom: (from, to) ->



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

		help: () ->
			alert("help")

		home: () ->
			context = @containerView.first()
			@containerView.switchView(context.view)

		hall: () ->
			@containerView.switchView(@hall_view)


	window.Home = new exports.HomeApplication

	ChatRoom.RouterManagement.register_router(ChatRoom.HomeRouter)


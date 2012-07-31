#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
														  

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "ChatRoom", (ex) ->


	class ex.ProfileView extends Backbone.View
		template: ChatRoom.template("profile/dialog")

		initialize: (@options) ->
			@mask_layout = new ex.MaskLayout(view: @)
			#@user = ex.OnlineUser.find_by_name(@options.user)

		render: () ->
			$(@el).html(@template())
			$("#layout").append(@el)
			#$(@mask_layout.el).append(@template())

	class ex.MaskLayout extends Backbone.View

		initialize: (@options) ->
			@append(@options.view)
			$(window).on 'keydown', $.proxy(@escape,@)
			@el = $("<div class='modal-backdrop' />").appendTo("body")

		append: (view) ->
			@view = view

		escape: (event) ->
			if event.keyCode == 27
				@close()

		close: () ->
			$(@el).remove()
			$(@view.el).remove()
			@remove()


	class ex.ProfileRouter extends Backbone.Router
		routes: {
			"profile/:user_name":        "profile"
		}

		profile: (user_name) ->
			# view = new ex.ProfileView(user: user_name)
			# view.render();		

		help: () ->
			alert("help")




ChatRoom.RouterManagement.register_router(ChatRoom.ProfileRouter)
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
		template_dialog: ChatRoom.template("profile/dialog")
		template_ember: ChatRoom.template("profile/ember")
		mini: {
			height  : 20,
			width   : 200
		}

		initialize: (@options) ->
			@template = @template_ember

		render: () ->

			$(@el).html(@template())
			[@origin_width, @origin_height] = [$(@el).width(), $(@el).height()]
			$(@el)
				.height(@mini.height)
				.width(@mini.width)
				.css('overflow', 'hidden') if @options.mini

			#$(@mask_layout.el).append(@template())
		getOriginSize: () ->
			[@origin_width, @origin_height]

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


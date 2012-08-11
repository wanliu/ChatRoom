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

	class ex.GameHallView extends Backbone.View

		template: ChatRoom.template("games/hall")

		events: {
			"click .start-game": "start_game"
		}

		render: () ->
			$(@el).html(@template())
			window.Home.getContainer().registerView (context) =>
				@game_view = new ex.GameRoomView(el: context.el)

		start_game: () ->
			window.Home.getContainer().switchView(@game_view)

	class ex.GameRoomView extends Backbone.View
		template: ChatRoom.template("games/game")

		render: () ->
			$(@el).html(@template())
			directions = ["bottom", "left", "top", "right"]
			@players = [ @owner(), @waitPlayer(), @waitPlayer(), @waitPlayer() ]
			@people_views = []
			for i in [0...4]
				pe = @make("div", {class: "people"}, "")
				@$(".peoples").append(pe)
				pv = new ex.PeopleCardView({
						el: pe, 
						direction: directions[i], 
						model: @players[i]
					})
				pv.render()

				@people_views.push pv

		owner: () ->
			Home.current_user

		waitPlayer: () ->
			new ex.User

	class ex.PeopleCardView extends Backbone.View
		template: ChatRoom.template("games/people_card")

		constructor: (@options) ->
			_.extend(@, @options)
			@$el = $(@el)

			@direction ||= "bottom"
			@container ||= $(@el).parent()

			@model.on('change', @show, @)
			# @model.fetch()
		render: () ->
			@$el.html(@template())

			switch @direction
				when "top", "bottom"
					$(@el)
						.addClass('horizontal')
						.css("position", "absolute")
						.css("left": "50%")
						.css("margin-left", "-100px")
						.css(@direction, 10)
					@$(".name")
						.css("position", "absolute")
						.css(@direction, 90)


				when "left", "right"
					$(@el)
						.addClass('vertical')
						.css("position", "absolute")
						.css("top": "50%")
						.css("margin-top", "-100px")
						.css(@direction, 10)
					@$(".name")
						.css("position", "absolute")
						.css("top", -28 )
					if @direction == "right"
						@$(".name")
							.css("right": 10)

					if @position == "left"
						@$(".name")
							.css("left", 10)


			@show(@model)


		show: (model) ->

			@$(".gravatar").attr("src", model.gravatar())
			@$(".name").text(model.display_name())



	class ex.PokerView extends Backbone.View













#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
														  

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com


namespace "ChatRoom.Game", (ex) ->

	VALID_COMMAND = /^\$(and|or)/ 
	COMMAND = /^\$(\w+)/

	# base : {
	# 	poker :[ {'3': 3 },4,5,6,7,8, 9,10,'J', 'Q', 'K', 'A', 2, 'Clown', 'King']
	# 	suit: ["spades", "hearts", "diamonds", "clubs"]
	# }
	#
	# Groups 基础语法
	# 	"String": 用引号包含字符代表一种符号,这个符号是有人来定义的,这是一种可变的符号
	# 不可变符号
	# 	::colon 		: 表示冒号
	# 	::comma 		: 表示逗号
	# 	::Lbrackets 	: 表示左中括号
	# 	::Rbrackets 	: 表示左中括号
	# 	::HASH   	    : 表示一个 hash
	#
	# 其本语法
	# 	"Name" ::colon "PATTERN"  # 定一个名为 Name 的模式
	# 	或
	#	"Name" ::colon Lbrackets "PATTERN" ::colon ::HASH ::Rbrackets 
	#    例:
	#		"DOUBLE"    : [ "$DOUBLE_KING",  {exclusion : true} ]
	#
	# 还有以下不同的基础语法
	#
	# 或连接, 满足其中一个 PATTERN 即成立
	# 语法: "Name" ::colon "PATTERN" ::comma "PATTERN" ... 
	# Example
	# 	"KING"		  : "Clown", "King"
	#
	# 与连接, 必须同时满足条件
	# 语法
	# 	"SameName" ::colon "PATTERN" 
	# 	"SameName" ::colon "PATTERN", ...
	# Example
	# 	"DOUBLE"      : "$A,$1"
	# 	"DOUBLE"      : "$DOUBLE_KING", {exclusion : true}
	#
	# PATTERN 详解
	# PATTERN 完整部分有两部分组成
	#	"STRING", HASH 		# 例 "$DOUBLE_KING", {exclusion : true}
	# 	当 PATTERN 没有 HASH 时, 启动 默认 HASH
	# 	当 PATTERN 与其它 PATTERN 或连接时, 可以使用 Array 语法来包含 Hash 选项
	#      "DOUBLE"      : ["$A,$1", { same_suit: true }, "$DOUBLE_KING" ]
	#	    对子:  满足两个规则之一 两个相同的 A 并且花色相同, 或两王
	# 
	# groups: {
	# 	"DOUBLE"      : "$A,$1"
	# 	"DOUBLE"      : "$DOUBLE_KING", {merge: true, exclusion : true}
	# 	"THREE"       : "$A,$1,$1", "$A,$1,$1,$A", "$A,$1,$1,$A,$A"
	#	"THREE"		  : "[$A, $1, $1], $A?, $A?"
	# 	"510K"        : "[5, 10, K]"
	# 	"BOOM"        : "$A,$1,$1,$1"
	# 	"KING"		  : "Clown", "King"
	#	"DRAGON"	  : "[$A, $<+1, $<+1, $<+1, $<+1 ]"
	# 	"DOUBLE_KING" :	"$KING,$KING"
	# }
	class Tree
		constructor: (@tree) ->

	class ex.Define
		constructor: (@name, rules, args...) ->
			@defines = []
			@parse(rules, @defines)

		parse: ( array, to = new Array) ->
			if array.length > 0
				[first, other...] = array
				if _.isString(first) && VALID_COMMAND.test(first) # first maybe  command
					m = COMMAND.exec(first)
					func = new Array
					method = @[m[1]]
					func.push method 
					to.push func
					@parseArguments(other, func)
				else # default or
					func = new Array
					method = @or
					func.push method
					func.push first.toString()
					to.push func
					@parseArguments(other, func)
			to

		parseArguments: (array, to) ->
			for a in array
				if _.isArray(a) # Array
					first = a[0]
					if _.isString(first) && VALID_COMMAND.test(first) # command
						@parse(a, to) 
					else 
						to.push a.toString()
				else # normal argument
					to.push a.toString()


		validate: (_values, defines = @defines[0]) ->
			[method, args...] = defines
			_values = [_values] unless _.isArray(_values)

			method_args = @calc.call(@, _values , args)
			method.call(@, _values, method_args )

		calc: (_values, args) ->
			_.map args, (arg) =>
				if _.isArray(arg) then @validate(_values, arg) else arg


		or: (_values, args) ->
			value = _values[0]
			console.log "or", args
			_.any args, (arg) -> arg == value


		and: (_values, args) ->
			value = _values[0]
			console.log "and", args
			_.all args, (arg) -> arg == value


	class ex.Base
		defines: []

		constructor: () ->
			@parseRules(@rules)		

		parseRules: (rules = {}) ->

			@parseDefine(rules.define)

		parseDefine: (defines = {}) ->

			for name, value of defines
				# def = []

				@defines.push 




	class PokerComparable

	class ex.Rule

	class ex.Poker 

		default_settings: {
			comparator: new PokerComparable
		}

		constructor: (@suit, @level, @options = {}) ->
			_.extend(@options, @default_settings)


	class ex.PokerGroup


	class CycleEnumerator 
		constructor: (@array) ->
			@index = 0

		startWith: (member) ->
			@index = @array.indexOf(member)

		next: () ->
			if @index + 1 >= @array.length then @index = 0 else @index++
			@array[i]

	ex.Player = {}
	class ex.Player.Base  
		constructor: (@user, @game) ->

		playing:(event) ->

		enable: () ->

		disable: () ->

	class ex.Command 

	class ex.HumanPlayer extends ex.Player.Base

		playing: (evnet) ->
			@game.last_pushs

	class ex.RemotePlayer extends ex.Player.Base


	class ex.Game5_10_K extends ex.Base

		rules: {
			define: {
				"A"           : [ '$or:1', 3,4,5,6,7,8,9,10,'J', 'Q', 'K', 'A', 2, 'Clown', 'King']
				"DOUBLE"      : [ '$andAll'  , "$A" , "<"]
				"THREE"       : [ '$andAll'  , "$A" , "<" ,	"<"	, "$A?","$A?"]
				"510K"        : [ '$andAll'  , 5 	, 10  ,	"K"	]
				"BOOM"        : [ '$andAll'  , "$A"	, "<" ,	"<"	, "<" ]
				"KING"		  : [ "Clown" , "King" ]
				"DOUBLE_KING" :	[ '$and'  , "$KING" , "$KING"]
			}
			compare: {
				"SPADES"      : ["= HEARTS", "= DIAMONDS", "= CLUBS"]
				"A"           : ["<",[3,4,5,6,7,8,9,10,'J', 'Q', 'K', 'A', 2, 'Clown', 'King']]
				"DOUBLE"      : ["<=>", "DOUBLE.level"]
				"THREE"       : ["THREE.level"]
				"510K"        : ["> $A", "> $DOUBLE", "> $THREE"]                                                            
				"KIND"        : ["> $A", "> $DOUBLE", "> $THREE", "> $510K"]                           
				"DOUBLE_KING" : ["> $A", "> $DOUBLE", "> $THREE", "> $510K", "> KIND"]
			}

		}



		start: () ->
			# cycle = new CycleEnumerator(@players)
			@pokers = randomPoker()


			i = 0
			for p in @players
				p.pull(@pokers[i..i+52/4])
				p.on("play", @waitPlaying, @)
				p.on("end", @endPlayed, @)
				i++

			@players[0].play()

		eachBefore: (event) ->
			event.player

		eachAfter: (event) ->
			if event.player.pokers.length ==　0	# win!
				@win()
			event.pushs 

		waitPlaying: (player) ->
			playing(player)

		endPlayed: (player) ->
			player.disable()

		win: () ->

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













#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
														  

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "Games", (ex) ->

	# base : {
	# 	poker :[ {'3': 3 },4,5,6,7,8, 9,10,'J', 'Q', 'K', 'A', 2, 'Clown', 'King']
	# 	suit: ["spades", "hearts", "diamonds", "clubs"]
	# }
	#
	# Groups 基础语法
	# 		"String": 用引号包含字符代表一种符号,这个符号是有人来定义的,这是一种可变的符号
	# 不可变符号
	# 		::colon 		: 表示冒号
	# 		::comma 		: 表示逗号
	# 		::Lbrackets 	: 表示左中括号
	# 		::Rbrackets 	: 表示左中括号
	# 		::HASH   	    : 表示一个 hash
	#
	# 其本语法
	# 		"Name" ::colon "PATTERN"  # 定一个名为 Name 的模式
	# 		或
	#		"Name" ::colon Lbrackets "PATTERN" ::colon ::HASH ::Rbrackets 
	#    	例:
	#			"DOUBLE"    : [ "$DOUBLE_KING",  {exclusion : true} ]
	#
	# 还有以下不同的基础语法
	#
	# 或连接, 满足其中一个 PATTERN 即成立
	# 语法: "Name" ::colon "PATTERN" ::comma "PATTERN" ... 
	# Example
	# 		"KING"		  : "Clown", "King"
	#
	# 与连接, 必须同时满足条件
	# 语法
	# 		"SameName" ::colon "PATTERN" 
	# 		"SameName" ::colon "PATTERN", ...
	# Example
	# 		"DOUBLE"      : "$A,$1"
	# 		"DOUBLE"      : "$DOUBLE_KING", {exclusion : true}
	#
	# PATTERN 详解
	# PATTERN 完整部分有两部分组成
	#		"STRING", HASH 		# 例 "$DOUBLE_KING", {exclusion : true}
	# 		当 PATTERN 没有 HASH 时, 启动 默认 HASH
	# 		当 PATTERN 与其它 PATTERN 或连接时, 可以使用 Array 语法来包含 Hash 选项
	#      	"DOUBLE"      : ["$A,$1", { same_suit: true }, "$DOUBLE_KING" ]
	#	    对子:  满足两个规则之一 两个相同的 A 并且花色相同, 或两王
	# 
	# groups: {
	# 	"DOUBLE"      : "$A,$1"
	# 	"DOUBLE"      : [ "$DOUBLE_KING", {merge: true, exclusion : true} ]
	# 	"THREE"       : [ "$A,$1,$1", "$A,$1,$1,$A", "$A,$1,$1,$A,$A" ]
	#	"THREE"		  : "[$A, $1, $1], $A?, $A?"
	# 	"510K"        : "[5, 10, K]"
	# 	"BOOM"        : "$A,$1,$1,$1"
	# 	"KING"		  : "Clown", "King"
	#	"DRAGON"	  : "[$A, $<+1, $<+1, $<+1, $<+1 ]"
	# 	"DOUBLE_KING" :	"$KING,$KING"
	# }

	class2type = {}

	_("Boolean Number String Function Array Date RegExp Object".split(" ")).each (name) ->
		class2type[ "[object " + name + "]" ] = name.toLowerCase()

	_type =  ( obj ) ->
		if obj == null then	String( obj ) else class2type[ toString.call(obj) ] || "object"

	isWindow = (obj) ->
		obj != null && obj == obj.window

	_.isHash ||= (obj) ->
		if !obj || _type(obj) != "object" || obj.nodeType || isWindow( obj )
			return false 


		try 
			# Not own constructor property must be Object
			if 	obj.constructor && !hasOwn.call(obj, "constructor") && !hasOwn.call(obj.constructor.prototype, "isPrototypeOf")  
				return false
		catch e
			# IE8,9 Will throw exceptions on certain host objects #9897
			return false;

		# Own properties are enumerated firstly, so to speed up,
		# if last one is own, then all properties are own.

		for key in obj 
			;

		return key == undefined || hasOwn.call( obj, key )

	unless String.prototype.trim
		String.prototype.trim = () ->
			@replace /^\s+|\s+$/g,''

	class ex.Context
		constructor: (@call) ->
			@context = []

		push: (object) ->
			@context.push [func, args]

		prev: (func, args) ->
			last = @context.pop()
			@context.push [func, args]
			@context.push last

		warp: (object) ->


	class ex.FuncContext extends ex.Context

	class ex.GroupContext extends ex.Context
		
	class ex.PatternContext extends ex.Context
		

	COMMAND_WITH = /^\$/g
	COMMAND_A_POKER = /^\$A/g
	COMMAND_A_NUMBER = /^\$(\d+)/g
	COMMAND_A_NAME = /^\$(\w+)/g
	COMMAND_PREV = /^\$\</g
	COMMAND_NORMAL_STRING = /(\w+)|(\d+)/g
	COMMAND_START_BRACKET = /^\[/
	COMMAND_END_BRACKET = /(.*?)\]/
	COMMAND_OPERATOR_NUMBER = /(\+|\-|\*|\/)(\d+)/
	COMMAND_OPTION = /\?/

	class ex.Executor
		constructor: (@context) ->

		or: (args...) ->
	
		pick: () ->

		pickEql: (number) ->

		pattern: (name) ->

		eql: (value) ->

		disorder: (array...) ->

		prevValue: (number) ->

		calc: (op, func, value ) ->




	class ex.GroupParser


		default_group_setting: {

		}

		constructor: (@groups, @executor) ->
			@context = @getContext()

		getContext: () ->
			context = []

			context.old_push = context.push

			_.extend(context, {
				push: (object) ->
					object.parent = @ if _.isArray(object)
					@old_push(object)

				warp: (object) ->

			})

		newPattern: (name) ->
			p = @getContext()
			p.name = name
			p.storage = []
			p

		newFunc: (name, args...) ->
			p = @getContext()
			p.push @executor[name]
			p.concat args if args.length > 0
			p

		findOrCreatePattern: (name, context = @context) ->
			pattern = _(context).find () ->
				patt.name == name
			pattern ||= newPattern(name)

		parse: (groups = @groups, context = @context) ->
			for name, exp in groups
				pattern = @findOrCreatePattern(name, context)
				pattern.push(@parseSections(exp, context))

		parseSections: (sections, context) ->
			if _.isArray(sections)
				pattern = @newFunc("or")
				for section in sections
					pattern.push @parseSections(section, pattern)
			else
				@parseExpression(sections, context)

		parseExpression: (exps, context) ->
			expressions = exps.split(",")

			for exp in expressions
				@parseCommand(exp, context)

		# 	"DOUBLE"      : "$A,$1"
		# 	Double = [ [pick], [ pickEql, 1 ]]

		# 	"DOUBLE"      : [ "$DOUBLE_KING", {merge: true, exclusion : true} ]
		# 	Double = [ pattern, "DOUBLE_KING" ]

		# 	"THREE"       : [ "$A,$1,$1", "$A,$1,$1,$A", "$A,$1,$1,$A,$A" ]
		#   Three = [ or , 
		#				[pick], [pickEql, 1], [pickEql, 1], 
		#				[pick], [pickEql, 1], [pickEql, 1], [pick]
		#				[pick], [pickEql, 1], [pickEql, 1], [pick], [pick]
		#			]

		# 	"510K"        : "[5, 10, K]"
		#   510K = [ disorder, [ eql, "5" ], [eql, "10"], [eql, "K"] ]

		#	"THREE"		  : "[$A, $1, $1], $A?, $A?"
		#   Three = [... [disorder, [pick, [pickEql, 1 ], [pickEql, 1]], [or, [picker]], [or, [picker]]]

		# 	"BOOM"        : "$A,$1,$1,$1"
		#	Boom = [ [pick], [pickEql, 1], [pickEql, 1], [pickEql, 1], [pickEql, 1]]

		# 	"KING"		  : [ "Clown", "King" ]
		#	King = [ [eql, "Clown"], [eql, "King"] ]

		#	"DRAGON"	  : "[$A, $<+1, $<+1, $<+1, $<+1 ]"
		#	Dragon = [ discorder, 
		# 				[[pick], 
		#	 			 [calc, '+', [pickPrevEql], 1], 
		#				 [calc, '+', [pickPrevEql], 1], 
		# 				 [calc, '+', [pickPrevEql], 1],
		# 				 [calc, '+', [pickPrevEql], 1]]
		# 			]

		# 	"DOUBLE_KING" :	"$KING,$KING"
		# 	Double_king = [
		# 		[pattern, "KING"],
		# 		[pattern, "KING"]
		# 	]	
		#

		parseCommand: (exp, context) ->
			# control string command
			if COMMAND_WITH.test(exp)
				# "$A"
				func = if COMMAND_A_POKER.test(exp)
					newFunc("pick")
				# "$1"
				else if COMMAND_A_NUMBER.test(exp)
					number = COMMAND_A_NUMBER.exec(exp)[1]
					newFunc("pickEql", number)
				# "$NAME"
				else if COMMAND_A_NAME.test(exp)
					name = COMMAND_A_NAME.exec(exp)[1]
					newFunc("pattern", name)
				# "[5, 10, K]" disorder group
				else if COMMAND_START_BRACKET(exp) 
					last = RegExp.rightContext
					func = newFunc("disorder")
					func.push @parseCommand(last)
				# "]"
				else if COMMAND_END_BRACKET.test(exp) 
					[]
				# "$<"
				else if COMMAND_PREV.test(exp)
					newFunc("prevValue")
				else
					throw "ErrorCommand"
				
				# [calc, '+', [prevValue], 1],
				while (last = RegExp.rightContext)?
					func = if COMMAND_OPERATOR_NUMBER.test(last)
						[__, op, value] = COMMAND_OPERATOR_NUMBER.exec(last)
						newFunc("calc", op, func, value)
					else if COMMAND_OPTION.test(last)
						newFunc("or", func)

			else # word
				func = newFunc("eql", exp)

			func

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

	class ex.GroupValidate
		constructor:(@groups) ->

		execute: (inputs, pattern) ->

		validate: (inputs) ->



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

		execute: (inputs, patterns) ->




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

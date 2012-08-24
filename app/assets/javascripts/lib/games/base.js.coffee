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
		

	COMMAND_WITH = /^\$/
	COMMAND_A_POKER = /^\$A/
	COMMAND_A_NUMBER = /^\$(\d+)/
	COMMAND_A_NAME = /^\$(\w+)/
	COMMAND_PREV = /^\$\</
	COMMAND_NORMAL_STRING = /(\w+)|(\d+)/
	COMMAND_START_BRACKET = /^\s*\[/
	COMMAND_END_BRACKET = /(.*?)\]/
	COMMAND_PURE_END_BRACKET = /^\s*\]/
	COMMAND_DOUBLE_BRACKET = /^\s*(\])\s*\]/
	COMMAND_BRACKET_COMMA = /^\s\]\,/
	COMMAND_WORD_END_BRACKET = /^([a-z|A-Z|0-9| '"\+\\\\=\-\$\>\<]+)\]/
	COMMAND_OPERATOR_NUMBER = /(\+|\-|\*|\/)(\d+)/
	COMMAND_OPTION = /\?/
	COMMAND_NEXT_COMMA = /(.*?)\,/

	PATTERN_NORMAL_NAME = /^(\w+)$/
	PATTERN_WITH = /^(\||\&)(\w+)/

	class ex.Executor
		constructor: (@context) ->

		or: (args...) ->
			# console.log "or"
			_(args).any (p) =>
				@callPattern(p)
	
		pick: () ->
			# console.log "pick"
			a = @input.readOne()
			a? && a != "" && @storage.push(a) > 0

		pickEql: (number) ->
			# console.log "pickEql#{number}"
			@storage[number]? && @storage[number] == @input.readOne()

		pattern: (name) ->
			# console.log "pattern:#{name}"
			p = @getPattern(name)
			throw "Invalid pattern name: #{name}" unless p?
			@callPattern(p)

		eql: (value) ->
			# console.log "eql:#{value}"
			value? && @input.readOne() == value

		disorder: (array...) ->
			# console.log "disorder"
			false

		prevValue: (number) ->
			# console.log "prevValue: #{number}"
			false

		calc: (op, func, value ) ->
			# console.log "calc: #{op}, #{func}, #{value}"
			false

	class ex.InputReader
		constructor: (@inputs) ->
			@current = _.clone(@inputs)

		readOne: () ->
			@current.shift()

	class ex.ExecutorRunner
		constructor: (@executor, @context) ->

		unwrap: (pattern) ->
			if _.isArray(pattern) && pattern.length == 1 && _.isArray(pattern[0])
				pattern = pattern[0] 
				@unwrap(pattern)
			else if _.isArray(pattern) && pattern.length == 1
				pattern = pattern[0]
			else
				pattern

		execute: (inputs, contexts = @context) ->
			if _.isArray(contexts)
				# 获取每一行 pattern
				for pattern in contexts
					pattern = @unwrap(pattern)
					# 每个 Sections
					if @isFunction(pattern)
						return pattern if @callFunc(pattern, inputs)
					else if _.isArray(pattern)
						success = _(pattern).all (p) =>
							@callFunc(p, inputs) if @isFunction(p)
						return pattern if success
			[]


		isFunction: (pattern) ->
			if _.isArray(pattern) 
				[func, args...] = pattern
				return _.isFunction(func)
			false

		callFunc: (pattern, inputs, parent) ->
			[func, args...] = pattern
			parent ||= pattern

			if _.isFunction(func) 
				context = new ex.ExecutorContext(inputs, @context, @, parent)
				func.apply(context, args)
			else
				_(pattern).all (p) =>
					@callFunc(p, inputs, pattern)




	class ex.ExecutorContext
		constructor: (@inputs, @patterns, @runner, @current_pattern) ->
			@input = new ex.InputReader(@inputs)
			@current_pattern.storage ||= []
			@storage = @current_pattern.storage

		getPattern: (name) ->
			_(@patterns).find (patt) ->
				patt.name == name
	
		callPattern: (pattern) ->
			@runner.callFunc(pattern, @inputs)



	class ex.GroupParser


		default_group_setting: {

		}

		constructor: (@executor = new Games.Executor, @groups = {}) ->
			@context = @getContext()

		getContext: () ->
			context = []

			context.old_push = context.push

			parser = @

			_.extend(context, {
				push: (args...) ->
					for a in args
						a.parent = @ if _.isArray(a)
					@old_push.apply(@, args)

				orJoin: (pattern) ->
					or_func = parser.newFunc("or")

					members = @splice(0, @length)

					or_func = or_func.concat (members)
					or_func.push pattern

					@unshift(or_func)
					@


				andJoin: (pattern) ->
					@push(pattern)
					@

				orConcat: (pattern) ->
					or_func = parser.newFunc("or")
					members = @splice(0, @length)
					@push or_func[0], members, pattern
					@

				andConcat: (pattern) ->
					@push pattern
					@


			})

		newPattern: (name) ->
			p = @getContext()
			p.name = name
			p.storage = []
			p

		newFunc: (name, args...) ->
			p = @getContext()
			p.push @executor[name]
			p = p.concat(args) if args.length > 0
			p

		nextExp: (exps) ->
			# [ xxx 
			if COMMAND_START_BRACKET.test(exps)
				[ '[', RegExp.rightContext ]			
			# xxx ]
			else if COMMAND_WORD_END_BRACKET.test(exps)
				next = COMMAND_WORD_END_BRACKET.exec(exps)[1]
				[ next.trim(), ']' + RegExp.rightContext ]
			# ]] 
			else if COMMAND_DOUBLE_BRACKET.test(exps)
				next = COMMAND_DOUBLE_BRACKET.exec(exps)[1]
				[ next.trim(), ']' + RegExp.rightContext ]
			# xxx, 
			else if COMMAND_NEXT_COMMA.test(exps) 
				next = COMMAND_NEXT_COMMA.exec(exps)[1]
				[ next.trim(), RegExp.rightContext ]
			# ]]]
			else if COMMAND_PURE_END_BRACKET.test(exps)
				[ ']', RegExp.rightContext ]
			# xxx
			else
				[ exps, ""]

		findOrCreatePattern: (name, context = @context) ->
			pattern = _(context).find () ->
				patt.name == name
			pattern ||= @newPattern(name)

		parse: (groups = @groups, context = []) ->
			relations = {
				'|': 'or'
				'&': 'and'
			}
			for name, exp of groups
				rel = 'and'
				if PATTERN_WITH.test(name)
					[x, symbol, name] = PATTERN_WITH.exec(name)

					rel = relations[symbol]
					throw "Parse Error! Invalid relation symbol: #{symbol} " unless rel 

				else if !PATTERN_NORMAL_NAME.test(name)
					throw "Parse Error! Invalid Pattern Name: #{name}"

				item = _(context).find (it) ->
					it.name == name

				unless item?
					item = @newPattern(name)
					context.push item

				rel_method = item["#{rel}Concat"]
				rel_method.call(item, @parseSections(exp))
 
			context

		parseSections: (sections) ->
				
			if _.isArray(sections) && sections.length > 1
				pattern = @newFunc("or")
				for section in sections
					pattern.push @parseSections(section)
				pattern
			else
				sections = sections[0] if _.isArray(sections)
				@parseExpression(sections)

		parseExpression: (exps) ->
			context = @getContext()

			while ([next_exp, exps ] = @nextExp(exps)).length > 0 && next_exp != ""
				if COMMAND_START_BRACKET.test(next_exp)
					[brackets, exps] = @parseBrackets(exps)
					context.push brackets
				else
					context.push @parseCommand(next_exp, context)

			context


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
		# 				 [pick], 
		#	 			 [calc, '+', [pickPrevEql], 1], 
		#				 [calc, '+', [pickPrevEql], 1], 
		# 				 [calc, '+', [pickPrevEql], 1],
		# 				 [calc, '+', [pickPrevEql], 1]
		# 			]

		# 	"DOUBLE_KING" :	"$KING,$KING"
		# 	Double_king = [
		# 		[pattern, "KING"],
		# 		[pattern, "KING"]
		# 	]	
		#

		parseCommand: (exp) ->
			# control string command
			exp = exp.trim()
			if COMMAND_WITH.test(exp)
				# "$A"
				func = if COMMAND_A_POKER.test(exp)
					@newFunc("pick")
				# "$1"
				else if COMMAND_A_NUMBER.test(exp)
					number = COMMAND_A_NUMBER.exec(exp)[1]
					@newFunc("pickEql", number)
				# "$NAME"
				else if COMMAND_A_NAME.test(exp)
					name = COMMAND_A_NAME.exec(exp)[1]
					@newFunc("pattern", name)
				else if COMMAND_END_BRACKET.test(exp) 
					throw "Parse Error, mismatch bracket `]`"
				# "$<"
				else if COMMAND_PREV.test(exp)
					@newFunc("prevValue")
				else
					throw "ErrorCommand"
				
				while (last = RegExp.rightContext.trim()) != '' && last?
					func = if COMMAND_OPERATOR_NUMBER.test(last)
						[__, op, value] = COMMAND_OPERATOR_NUMBER.exec(last)
						@newFunc("calc", op, func, value)
					else if COMMAND_OPTION.test(last)
						@newFunc("or", func)
					else
						throw "ParseError ,Invalid Format"

			else # word
				func = @newFunc("eql", exp)

			throw "Parse Error , invalid command #{exp}" unless func?

			func

		parseBrackets: (exps) ->
			func = @newFunc("disorder")
			while ([next_exp, exps ] = @nextExp(exps)).length > 0 && next_exp != ""

				if COMMAND_START_BRACKET.test(next_exp)
					[nested, exps ] =  @parseBrackets(exps)
					func.push nested
					continue

				if COMMAND_PURE_END_BRACKET.test(next_exp)
					return [func, exps]

				else
					exp = next_exp

				func.push @parseCommand(exp)

			[func, exps]

	class ex.GameRules

		constructor: (@executor, @rules) ->
			@groups_parser = new ex.GroupParser(@executor)
			@groups = @groups_parser.parse(@rules.groups)


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
			_.any args, (arg) -> arg == value


		and: (_values, args) ->
			value = _values[0]
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

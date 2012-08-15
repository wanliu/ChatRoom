describe "Game Rules Define", () ->

	beforeEach () ->
#		@group = new Games.Group


	it "or Pattern ", () ->

	it "parseItem", () ->
		# @group.parseItem("pattern")


	it "parsePattern", () ->

		# results = @group.parsePattern("[5, 10, K]")
		
		# expect(results[0]).toBe("[5")
		# expect(results[1]).toBe("10")
		# expect(results[2]).toBe("K]")



	# describe "GroupValidate", () ->
	# 	beforeEach () ->
	# 		@validate = new Games.GroupValidate()

	# 	it "validate DOUBLE pattern ", () ->

	# 		@validate.execute(['A', 'A'], pattern)

	throughArray = (array)->
		p = array
		while (_.isArray(p) && p.length == 1 && p = p[0])
			;
		p

	arrayCompare = (array1, array2) ->
		array2 = [array2] unless _.isArray(array2)

		_(array1).all (a, i) ->
			b = array2[i]
			if _.isArray(a) && a.length > 1
				arrayCompare(a, b)
			else
				a = throughArray(a)
				b = throughArray(b)
				if _.isArray(a) && a.length > 1
					arrayCompare(a, b)
				else
					a == b



	describe "GroupParser", () ->
		beforeEach () ->
			groups = {
				"DOUBLE"      : "$A,$1"
				"|DOUBLE"	  : [ "$DOUBLE_KING" ]
				"&DOUBLE"	  : [ "$DOUBLE_KING" ]

			}

			@executor = new Games.Executor
			@methodPick = @executor.pick
			@methodPickEql = @executor.pickEql
			@methodPattern = @executor.pattern
			@methodDisorder = @executor.disorder
			@methodEql = @executor.eql
			@methodOr = @executor.or
			@methodCalc = @executor.calc
			@methodPrevValue = @executor.prevValue							

			@parser = new Games.GroupParser(@executor, groups)


			@addMatchers({
				toPattern: (expected) ->
					sheller = @actual
					while ((_.isArray(sheller) && sheller.length == 1) && sheller = sheller[0])
						result = _(expected).all (e, i) ->
							sheller[i] == e || arrayCompare(sheller[i], e) || throughArray(sheller[i]) == e
						return true if result 

					arrayCompare(sheller, expected)
				
			})

		it "parser.parser or join", () ->

			results = @parser.parse({
				"DOUBLE"      : "$A,$1"
				"|DOUBLE"	  : [ "$DOUBLE_KING" ]				
				"THREE"       : [ "$A,$1,$1", "$A,$1,$1,$A", "$A,$1,$1,$A,$A" ]
				"510K"        : "[5, 10, K]"
				})

			[or_func, one, two] = results[0]
			expect(or_func).toBe(@methodOr)
			expect(one).toPattern([@methodPick, [@methodPickEql, '1']])
			expect(two).toPattern([@methodPattern, 'DOUBLE_KING' ])

			# match [ "$A,$1,$1", "$A,$1,$1,$A", "$A,$1,$1,$A,$A" ]
			expect(results[1]).toPattern([@methodOr,
				[@methodPick, [@methodPickEql, '1'], [@methodPickEql, '1']],
				[@methodPick, [@methodPickEql, '1'], [@methodPickEql, '1'], @methodPick],
				[@methodPick, [@methodPickEql, '1'], [@methodPickEql, '1'], @methodPick, @methodPick]
			])

			# match "[5, 10, K]"
			expect(results[2]).toPattern([@methodDisorder, [@methodEql, '5'], [@methodEql, '10'], [@methodEql, 'K']])




		it "parseExpression", () ->
			results = @parser.parseExpression("$A,$1")

			[one, two] = results

			expect(results.length).toBe(2)
			expect(one).toContain(@methodPick)
			expect(two).toContain(@methodPickEql)

		it "parseCommand $A", () ->

			results = @parser.parseCommand("$A")
			expect(results).toContain(@methodPick)

		it "parseCommand $1", () ->

			results = @parser.parseCommand("$1")
			expect(results).toContain(@methodPickEql)
			expect(results).toContain('1')

		it "parseCommand $DOUBLE_KING", () ->

			results = @parser.parseCommand("$DOUBLE_KING")
			expect(results).toContain(@methodPattern)
			expect(results).toContain('DOUBLE_KING')

		it "parseExpression '$A,$1,$1'", () ->

			results = @parser.parseExpression("$A,$1,$1")

			[one , two, three] = results
			expect(one).toContain(@methodPick)

			expect(two).toContain(@methodPickEql)
			expect(two).toContain('1')

			expect(three).toContain(@methodPickEql)
			expect(three).toContain('1')

		it "parseExpression '[5, 10, K]'", () ->
			results = @parser.parseExpression("[5, 10, K]")
			[func, five, ten , k ] = results[0]

			expect(func).toBe(@methodDisorder)

			expect(five).toContain(@methodEql)
			expect(five).toContain('5')
			expect(ten).toContain(@methodEql)
			expect(ten).toContain('10')
			expect(k).toContain(@methodEql)
			expect(k).toContain('K')

		it "parseExpression '[' nested '[5, 10, [K, A], King]'", () ->
			results = @parser.parseExpression("[5, 10, [K, A], King]")
			[func, five, ten , k ] = results[0]

			expect(results[0]).toPattern(
				[ @methodDisorder, 
					[ @methodEql, '5'], 
					[ @methodEql, '10'], 
					[ @methodDisorder, 
						[ @methodEql, 'K'], 
						[ @methodEql, 'A']], 
					[ @methodEql, 'King']
				])

		it "parseExpression '[' deep nested [ 3, 4, [ 5 , 10 , [J , Q, [ K, A , 2, [Clown]], King]], 6]", () ->
			results = @parser.parseExpression("[ 3, 4, [ 5 , 10 , [J , Q, [ K, A , 2, [Clown]], King]], 6]")

			console.log results

			expect(results[0]).toPattern(
				[ @methodDisorder, 
					[ @methodEql, '3'], 
					[ @methodEql, '4'], 
					[ @methodDisorder, 
						[ @methodEql, '5'], 
						[ @methodEql, '10'],
						[ @methodDisorder,
							[ @methodEql, 'J' ],
							[ @methodEql, 'Q' ],
							[ @methodDisorder, 
								[ @methodEql, 'K' ],
								[ @methodEql, 'A' ],
								[ @methodEql, '2' ],
								[ @methodDisorder, 
									[ @methodEql, 'Clown' ]
								]
							],
							[ @methodEql, 'King' ]
						]
					],
					[ @methodEql, '6' ]
				])

		it "Other 1 parseExpression '[' deep nested [[[ 3, 4, ], 5 ], 6 ]" , () ->
			results = @parser.parseExpression("[[[ 3, 4, ], 5 ], 6 ]")
			expect(results[0]).toPattern(
				[ @methodDisorder,
					[ @methodDisorder ,
						[ @methodDisorder ,
							[ @methodEql, '3' ],
							[ @methodEql, '4' ]
						], 
						[ @methodEql, '5' ]
					],
					[ @methodEql, '6' ]
				])

		it "Other 2 parseExpression '['' deep nested [[[ 3 ], 5 ], 6 ]" , () ->
			results = @parser.parseExpression("[[[ 3 ], 5 ], 6 ]")
			expect(results[0]).toPattern(
				[ @methodDisorder,
					[ @methodDisorder ,
						[ @methodDisorder ,
							[ @methodEql, '3' ]
						], 
						[ @methodEql, '5' ]
					],
					[ @methodEql, '6' ]
				])


		it "Other 3 parseExpression  '['' deep nested [3, [4 , [ 5 ]]]" , () ->
			results = @parser.parseExpression("[3, [4 , [ 5 ]]]")
			expect(results[0]).toPattern(
				[ @methodDisorder,
					[ @methodEql, '3' ],
					[ @methodDisorder ,
						[ @methodDisorder ,
							[ @methodEql, '4' ],
							[ @methodDisorder, 
								[ @methodEql, '5' ]
							]
						]
					]
				])

		it "Other 4 parseExpression '[' deep nested  [3, [4 , [ 5, 6]]]'  " , () ->
			results = @parser.parseExpression("[3, [4 , [ 5, 6 ]]]")
			expect(results[0]).toPattern(
				[ @methodDisorder,
					[ @methodEql, '3' ],
					[ @methodDisorder ,
						[ @methodDisorder ,
							[ @methodEql, '4' ],
							[ @methodDisorder, 
								[ @methodEql, '5' ],
								[ @methodEql, '6' ]
							]
						]
					]
				])



		it "parseExpression '[$A, $1, $1], $A?, $A?'", () ->

			results = @parser.parseExpression("[$A, $1, $1], $A?, $A?")
			[array, option1, option2 ] = results

			[func, one, two , three] = array
			expect(func).toBe(@methodDisorder)
			expect(one).toContain(@methodPick)
			expect(two).toContain(@methodPickEql)
			expect(two).toContain('1')

			expect(three).toContain(@methodPickEql)
			expect(three).toContain('1')

			[wrapper, func] = option1
			expect(wrapper).toBe(@methodOr)
			expect(func).toContain(@methodPick)

			[wrapper, func] = option2
			expect(wrapper).toBe(@methodOr)
			expect(func).toContain(@methodPick)

		it "parseExpression '[$A, $<+1, $<+1, $<+1, $<+1 ]'", () ->

			results = @parser.parseExpression("[$A, $<+1, $<+1, $<+1, $<+1 ]")

			[func, one, two, three, four, five] = results[0]
			expect(func).toBe(@methodDisorder)
			expect(one).toContain(@methodPick)

			[calc_func, op , [func], number] = two
			expect(calc_func).toBe(@methodCalc)
			expect(op).toBe('+')
			expect(func).toBe(@methodPrevValue)
			expect(number).toBe('1')

			[calc_func, op , [func], number] = three
			expect(calc_func).toBe(@methodCalc)
			expect(op).toBe('+')
			expect(func).toBe(@methodPrevValue)
			expect(number).toBe('1')

			[calc_func, op , [func], number] = four
			expect(calc_func).toBe(@methodCalc)
			expect(op).toBe('+')
			expect(func).toBe(@methodPrevValue)
			expect(number).toBe('1')

			[calc_func, op , [func], number] = five
			expect(calc_func).toBe(@methodCalc)
			expect(op).toBe('+')
			expect(func).toBe(@methodPrevValue)
			expect(number).toBe('1')



		it "parseExpression 'Clown' ", () ->

			results = @parser.parseExpression('Clown')
			results = results[0]
			expect(results).toContain(@methodEql)
			expect(results).toContain('Clown')

		compareSections = (results) ->
			expect(results).toPattern([@methodOr, [@methodEql, 'Clown'], [@methodEql, 'King']])


		it "parseSections ['Clown', 'King'] ", () ->
			compareSections.call @, @parser.parseSections(['Clown', 'King'])

		it "parseExpression '$KING,$KING'", () ->
			results = @parser.parseExpression("$KING,$KING")
			expect(results).toPattern([[@methodPattern, 'KING'], [@methodPattern, 'KING']])



		it "newFunc", () ->

			results = @parser.newFunc("pickEql", 1)

			expect(results[0]).toBe(@methodPickEql)
			expect(results[1]).toBe(1)


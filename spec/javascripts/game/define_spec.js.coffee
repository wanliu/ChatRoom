describe "Game Rules Define", () ->

	beforeEach () ->
		@group = new Games.Group


	it "or Pattern ", () ->

	it "parseItem", () ->
		# @group.parseItem("pattern")


	it "parsePattern", () ->

		results = @group.parsePattern("[5, 10, K]")
		
		expect(results[0]).toBe("[5")
		expect(results[1]).toBe("10")
		expect(results[2]).toBe("K]")



	describe "GroupValidate", () ->
		beforeEach: () ->
			@validate = new Games.GroupValidate()

		it "validate DOUBLE pattern ", () ->

			@validate.execute(['A', 'A'], pattern)


	describe "GroupParser", () ->
		beforeEach: () ->
			@parser = new Games.GroupParser()


		it "parse Double", () ->
			;

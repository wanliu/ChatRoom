window.Viewport = {}

$$$ = (ex) -> 
	class ex.Context

		constructor: (@el, @klass) ->


	class ex.Manager

		__viewport_manager = null
		__viewports_views = []

		manager = () =>
			__viewport_manager ||= new @

		registerView = (options) ->
			view = @reflectKlass(options)
			__viewports_views.push view
			view

		reflectKlass: (options) ->
			Klass = options.klass || ex.Context
			delete options.klass
			new Klass(options)		

	# PatternViewportManager.registerPattern("hall", {
	# 	init: (viewport)->
	# 		view = new GameHallView(el : viewport.el )
	# 		viewport.register(view)
	#
	# 	onRender:(viewport) ->
	# 		viewport.render()
	# 	}
	class ex.PatternManager extends ex.Manager

		__pattern_views = {}

		@registerPattern = (pattern, options) ->
			manager().registerPattern(pattern, options)

		registerPattern: (pattern, options) ->
			__pattern_views[pattern] ||= @registerView(options)

	class ex.Callback


$$$(window.Viewport)
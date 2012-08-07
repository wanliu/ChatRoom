#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "Viewport", (ex) ->


	class ex.Context
		constructor: (@pattern, @container, config)->
			@index = @container.child_index++
			@parent = $(@container.el)
			_.extend(@, config)

		switch: () ->
			old_active = if @parent.find(">div.active")[0]? then @parent.find(">div.active") else @parent.find(">div:first-child")

			if old_active?
				@container.effect.enterScene(old_active)

				@parent.find(">div").removeClass("active")
				$(@el).addClass("active")
				@view && @view.render()

				@container.effect.transition()
			#@container.effect.revertScene()


	class ex.Effect 

		constructor: (args...) ->
			@initialize && @initialize.apply(@, args)

		enterScene: () ->

		transition: () ->

		revertScene: () ->

		saveCss: (element) ->
			raw_styles = element.get(0) && element.get(0).style
			styles = {} 
			for s in raw_styles
				styles[s] = raw_styles[s]

			styles


	class ex.EffectBuilder
		constructor: (@contrainer_view) ->


		build: (block) ->
		 	effect = block.call(@, @)
		 	prototypes = _.extend(ex.Effect.prototype, effect)
		 	klassEffect = _.extend(ex.Effect, {prototype: prototypes})
		 	new klassEffect(@contrainer_view)



	class ex.ContainerView extends Backbone.View

		__child_views = {}

		parent_element: ["div", { class: "container-view" }, ""]
		child_element: ["div"]
		constructor: () ->
			@child_index = 0
			super

		render: ()->

		setElement: (@element, options = {}) ->
			view = new Backbone.View
			parent_element = options.parent_element || @parent_element

			@parent = view.make.apply(view, parent_element)
			child = @allocChild(options)

			children = $(@element).children()

			if children.length > 0
				$(@element).children().appendTo(child)

				context = new ex.Context("first_view", @, el: child, parent: $(@parent))

				firstView = null
				@registerView (context) => 
					firstView = new Backbone.View(el: context.el )
					firstView.setElement(context.el)
					firstView
				, context: context

			$(@element).append(@parent)

			# @effect ||= new ex.SlideEffect(element)

			super @parent

		allocChild: (options = {}) ->
			view = new Backbone.View
			child_element = options.child_element || @child_element
			child = view.make.apply(view, child_element)
			$(@parent).append(child)
			child

		registerEffect: (block) ->

			eb = new ex.EffectBuilder(@)
			@effect = eb.build block


		registerView: (name_or_handle, args...) ->
			[name, register_handle] = if typeof name_or_handle == "function" then [name_or_handle, name_or_handle] else [name_or_handle, args.shift()]
			[options, args...] = args
			options ||= {}

			unless __child_views[name]?
				if options.context?
					context = options.context
				else
					context = new ex.Context(name, @)
					context.el = @allocChild()

				context.handle = register_handle
				__child_views[name] = context

				context.view = __child_views[name].handle.call(@, context)

		unregisterView: (name_or_view) ->
			if name_or_view == "string"
				delete __child_views[name_or_view]
			else
				_child = null
				context = _(__child_views).find (child) ->
					_child = child
					child.view == name_or_view

				delete __child_views[_child]
			# delete context

		default_render_handle = (context) ->
			context.switch()

		switchView: (name_or_view, args...) ->

			handle = args.pop() || default_render_handle

			context = fetchContext(name_or_view)

			handle.call(@, context)

		fetchContext = (name_or_view) ->
			if name_or_view == "string"
				context = __child_views[name_or_view] || throw new Error("invalid pattern name")
			else
				context = _(__child_views).find (child) ->
					child.view == name_or_view

		first: () ->
			_(__child_views).min (child) ->
				child.index 

		last: () ->
			_(__child_views).max (child) ->
				child.index


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

	class ex.LanternView

		constructor: (element) ->
			@wrap(element) if element? 

		wrap: (element) ->
			@container = $(element)
			@wrapper = $("<ul class='lantern unstyled' />")
			
			place = @appendElement(@container.children())
			@container.append(@wrapper)

		allocChild: (parent = @wrapper, changeCurrent = true) ->
			child = $("<li/>")
			setCurrent(child) if changeCurrent
			$(child).appendTo(parent)

		current: () ->
			@current

		next: () ->
			next = @current.next()
			setCurrent(next)
			next

		previous: () ->
			previous = @current.previous()
			setCurrent(previous)
			previous

		append: (view) ->
			@appendElement(view.el)

		appendElement: (element) ->
			child = @allocChild()
			$(element).appendTo(child)

		# private 
		setCurrent = (el) ->
			@current && $(@current).removeClass('active')
			@current = el
			@current.addClass('active')


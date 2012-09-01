
#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "MessageService", (ex) ->

	class ex.EventSourceAdapter extends ex.AbstractAdapter

		constructor: (@options) ->
			@caller = @options.caller || new ex.MessageHandler
			@url    = @options.url || "/stream"
			@bound_adapter = @options.bound_adapter || new EventSource(@url)
			@registed_message_queues = {}

		subscribie: (name, callback) ->
			handler = @caller.handle(callback)
			@bound_adapter.addEventListener(name, handler, false)

		unsubscribe: (name) ->
			@bound_adapter.removeEventListener(name)

		subscribies: (args..., callback) ->
			for event_name in args
				@subscribie(event_name, callback)

		sendObject: (url = @url, hash, options) ->
			$.post(url, hash, options)

		onopen: (callback) ->
			@bound_adapter.onopen = callback

		onerror: (callback) ->
			@bound_adapter.onerror = callback

		onmessage: (callback) ->
			@bound_adapter.onmessage = callback

		onclose: (callback) ->
			@bound_adapter.onclose = callback

		close: () ->
			@bound_adapter.close()


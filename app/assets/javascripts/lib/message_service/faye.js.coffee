#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com
# 	

namespace "MessageService", (ex) ->

	class ex.FayeAdapter extends ex.AbstractAdapter

		constructor: (@options) ->
			@caller = @options.caller || new ex.MessageHandler
			@url    = @options.url || "/faye"
			@client = @options.bound_adapter || new Faye.Client(@url)

			@message_register_queues = {}

		subscribie: (name, callback) ->
			handler = @caller.handle(callback)
			subscription = @message_register_queues[name]
			subscription.cancel() if subscription?
			subscription = @client.subscribe(name, handler)
			@message_register_queues[name]	= subscription


		unsubscribe: (name) ->

			subscription = @message_register_queues[name]
			subscription.cancel() if subscription?

		subscribies: (args..., callback) ->
			for event_name in args
				@subscribie(event_name, callback)

		sendObject: (url, hash, options) ->
			@client.publish(url, hash)

		onopen: (callback) ->
			@client.bind('transport:up', callback)

		onclose: (callback) ->
			@client.bind('transport:down', callback)

		close: () ->
			@client.close()		
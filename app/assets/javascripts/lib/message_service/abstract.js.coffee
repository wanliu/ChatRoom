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
namespace "MessageService",  (ex) ->

	class ex.AbstractAdapter

		constructor: (@options) ->

		subscribe: (name, callback) ->

		subscribies: (args..., callback) ->

		sendObject: (url, hash, options) ->

		unsubscribe: (name) ->

		onmessage: (callback) ->

		onopen: (callback) ->

		onerror: (callback) ->

		onclose: (callback) ->

		close: () ->
#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "ChatRoom.RouterManagement", (ex) ->

	router_singleton_class = []

	ex.register_router = (klass) ->
		router_singleton_class.push klass

	ex.start = () ->
		_(router_singleton_class).each (klass, i) ->
			new klass

		console.log 'start'
		Backbone.history.start()

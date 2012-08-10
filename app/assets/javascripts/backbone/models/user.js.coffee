#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
                                                          

# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0

# author: hysios@gmail.com

namespace "ChatRoom", (exports) ->
	class exports.User extends Backbone.Model
		ASSEST_PREFIX = "/assets/"
		urlRoot: "/users"

		@current_user = ()->
			user = new @
			user.fetch url: "#{user.url()}/current_user"
			user

		gravatar_url: () ->
			@attributes.gravatar || ASSEST_PREFIX + "nobody.jpeg"

		gravatar: () ->
			@gravatar_url()

		display_name: () ->
			@get("nickname") || @get("email")


	class exports.OnlineUser extends exports.User


	class exports.Users extends Backbone.Collection
		url: "/users"
		model: exports.User



	class exports.OnlineUsers extends exports.Users
		model: exports.OnlineUser
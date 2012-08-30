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

		gravatar_url: (options = {}) ->
			urls = [@attributes.gravatar]
			
			for key,value of options
				urls.push(key + "=" + value)
			
			urls.join("&") || ASSEST_PREFIX + "nobody.jpeg"

		gravatar: (options = {}) ->
			@gravatar_url(options)

		display_name: () ->
			@get("name") || @get("email")


	class exports.OnlineUser extends exports.User



	class exports.Users extends Backbone.Collection
		url: "/users"
		model: exports.User



	class exports.OnlineUsers extends exports.Users
		model: exports.OnlineUser


	class exports.RoomUsers extends exports.OnlineUsers
		room: null

		setRoom: (room) ->
			@room = room

		getRoom: () ->
			@room

		initialize: (@options) ->
			_.extend(@, @options)

		fetch: (options = {}) ->
			if @room? && !options.url?
				url = "/rooms/#{@room.id}/members"
				_.extend(options, {url: url})

			super(options)

		fetchUserName: (name) ->
			url = "/rooms/#{@room.id}/member/#{name}"
			@fetch(url: url, wait: true)

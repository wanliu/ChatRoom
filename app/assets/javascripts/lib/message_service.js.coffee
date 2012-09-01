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
#= require_tree "./message_service"


# 消息注册服务
# 使用方法
#   首先初始化配置
# 	MessageService.initialize (config) ->
# 		# 消息订阅主地址
# 		config.url = "/stream"
# 		# 指定消息低层适配器, 默认是 EventSource 机制
# 		config.adapter = new @EventSourceAdapter("/stream")
# 		# 指定消息处理器
# 		config.message_handler = new @MessageHandler
#
# 		
# 	注册消息
# 	listener = MessageService.registerListener("room_#{room_id}", {
# 		connecting: () ->
# 		connected:  () ->
# 		prepare_message: () ->
# 		onmessage: () ->
# 		disconnect: () ->
# 		requisition: () ->
# 		other: () ->
# 		each: () ->	
# 	}
# 	
# 	MessageService.registerMessage("room_#{room_id}", @)
# 	
# 	class ex.ChatView extends ex.MessageView
# 		
# 		messages: {
# 			"connecting"        : "connecting"
# 			"connected"			: "connected"
# 			"prepare_messaging" : "prepare_messaging"
# 			"onmessage"         : "onmessage",
# 			"disconnect"        : "disconnect"
# 			"requisition"       : "requisition",
# 			"each"              : "each"
# 		}
# 		
# 		initialize: (options) ->
# 			@registerListener("room_#{room_id}")
# 			
# 			
# 		connecting: (event) ->
# 			prompt = getFloatingPrompt()
# 			prompt.text("user #{event.username} connecting this room")
# 			prompt
# 				.attr("username", event.username)
# 				.attr("message-state", "connecting")
# 			
# 			
# 		connected: (event) ->
# 			prompt = getFloatingPrompt(event.username)
# 			prompt.text("user #{event.username} connecting this room")
# 			prompt.attr("message-state", "connected")
# 				
# 			
# 		disconnect: (event) ->
# 		
# 		prepare_message: (event) ->
# 			prompt = getFloatingPrompt()
# 			prompt.text("user #{event.username} connecting this room")
# 			
# 		onmessage: (event) ->
# 			prompt = getFloatingPrompt(event.username)
# 			prompt.text("#{event.username} : #{event.data}")
# 			prompt.moveToLast()
# 			
#

namespace "MessageService", (ex) ->

	# 私有的单例服务句柄
	standalone_service = null 

	ex.initialize = (handle) ->

		config = {
			url             : "/stream",
			adapter         : "EventSource", 
			message_handler : new @MessageHandler
		}
		handle.call(@, config) if handle?
		
		standalone_service ||= new ex.StandaloneService(config)

	ex.registerMessage = (name, callback) ->
		return false unless standalone_service?

		standalone_service.registerMessage(name, callback)

	ex.unregisterMessage = (name) ->
		return false unless standalone_service?

		standalone_service.unregisterMessage(name)

	ex.sendObject = (url, object_hash) ->
		return false unless standalone_service?

		standalone_service.sendObject(url, object_hash)

	ex.close = () ->
		standalone_service.close()


	class ex.StandaloneService
		constructor: (@options = {}) ->
			@url = @options.url || "/stream"
			if _.isString(@options.adapter)
				name = @options.adapter
				klass = ex[name + "Adapter"]
			else if _.isFunction(@options.adapter)
				klass = @options.adapter

			if klass?
				@adapter ||= new klass(
					url    : @url, 
					caller : @options.message_handler)

				@adapter.onmessage(@options.onmessage) if @options.onmessage?
				@adapter.onopen(@options.onopen) if @options.onopen?
				@adapter.onerror(@options.onerror) if @options.onerror?
				@adapter.onclose(@options.onclose) if @options.onclose?


		registerMessage: (name, callback) ->
			@adapter.subscribie(name, callback)

		unregisterMessage: (name) ->
			@adapter.unsubscribe(name)

		sendObject: (url, hash, options) ->
			@adapter.sendObject(url, hash, options)

		close: () ->
			@adapter.close()




	class ex.MessageHandler

		constructor: (@options = {}) ->
			@_before_callbacks = @options.before_callbacks || []
			@_after_callbacks  = @options.after_callbacks || []
			@doHandle ||= @options.doHandle

			bind_array_function = (object) ->
				object.run = (context) ->
					context ||= @
					for callback in @
						callback.call(context, callback)

			bind_array_function(@_before_callbacks)
			bind_array_function(@_after_callbacks)


		handle: (callback) ->
			(event) =>
				@_before_callbacks.run()
				@doHandle(callback, event)
				@_after_callbacks.run()

		doHandle: (callback, event) ->

			callback(event)





namespace 'ChatRoom' ,(exports) ->

	class exports.RoomsView extends ChatRoom.MessageView

		template: ChatRoom.template('home/room')
		create_room_template: ChatRoom.template("home/create_room")
	
		events: {
			'click .new_room'	 	:	'new_room'
			'click .create_room' 	:	'create_room'
			'click .cancel_room' 	:	'cancel_room'			
		}

		messages: {
			'add_room': "add_room"
			'remove_room' : 'remove_room'
		}

		initialize: (options) ->
			_.extend(@,options)
			this.$el = $(this.el)
			@rooms = new exports.Rooms
			@rooms.on("reset", @renderAllRoom, @)
			@rooms.on("add", @renderOneRoom, @)
			@rooms.fetch()
			$(@el).html(@template)
			@$leftnav = @$('.left-nav')
			@registerListener("rooms")

		
		render: () ->

			
		refresh: () ->
			@rooms.fetch()

		add_room: (event) ->
			result = JSON.parse(event.data)
			room = new exports.Room(id : result.room_id)
			@rooms.add(room)
			room.fetch()


		remove_room: (event) ->
			result = JSON.parse(event.data)
			room = @rooms.get(result.room_id)
			@rooms.remove(room)


		new_room: () ->
			@$(".dialog")
				.hide()
				.html(@create_room_template())
			@$(".dialog").slideDown()
			

		create_room: ()	->
			room_name = @$('#room_name').val()
			if room_name.length != 0
				@$('.dialog').slideUp()
				room = new exports.Room
				room.save({name: room_name}) 
				@rooms.add(room)
			else
				alert("give it a name ,please")		


		cancel_room: () ->
			@$('.dialog').slideUp()

		renderAllRoom: () ->
			@$leftnav.html(' ')
			@rooms.each $.proxy(@renderOneRoom, @)

		renderOneRoom: (model) ->
			model = new exports.Room(model) unless model.constructor == ChatRoom.Room
			view = new exports.RoomButtonView(model: model, parent_view: @parent_view)
			@$leftnav.append(view.render().el)		
				

	class exports.RoomButtonView extends Backbone.View

		tagName: 'li'
		className: 'room_button'
		

		events:  {
			"click"		: "joinRoom"
			'mouseover'	: 'roomDetail'
			'mouseleave': 'detaildown'
		}

		initialize: (options) ->
			_.extend(@, options)
			@members  = new exports.RoomUsers(room: @model)
			

		render: () ->
			$(@el).html(@model.get("name"))
			@

		joinRoom: () ->
			@model.enter () =>
				@switchView()

		roomDetail: () ->	
			@user = new ChatRoom.User( "id" : @model.get('onwer'))		
			@user.fetch(async : false)
			# @members.fetch()
			# ast = @members.models[0].attributes
			@$el
				.attr( "rel","popover")
				.attr("data-original-title","房主:#{@user.get('name')},创建于:#{@user.get('created_at')}")
				.attr("data-content","通告板:这是我的地盘")
			@$el.popover('show')		



		detaildown: () ->
			@$el.popover('hide')


		switchView: () ->
			unless @chat_view?
				@chat_view = new exports.ChatView(el: $("<div/>"), model: @model)
				@chat_view.render()
				@parent_view.addPane(@model.get("name"), @chat_view, @)

			@parent_view.active(@model.get("name"))

# 




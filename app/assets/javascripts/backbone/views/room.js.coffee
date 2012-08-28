namespace 'ChatRoom' ,(exports) ->

	class exports.RoomsView extends Backbone.View

		template: ChatRoom.template('home/room')
		create_room_template: ChatRoom.template("home/create_room")
	
		events: {
			'click .new_room'	 	:	'new_room'
			'click .create_room' 	:	'create_room'
			'click .cancel_room' 	:	'cancel_room'
			'click .rooms_names' 	:	'rooms_detail'
			'dblclick .rooms_names'  :	'enter_room'
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
			#@containerView = window.Home.getContainer()
		
		render: () ->

			
		refresh: () ->
			@rooms.fetch()


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
			view = new exports.LeftnavView(model: model)
			@$leftnav.append(view.render().el)
			# context = @containerView.first()
			# @containerView.switchView(context.view)
		
		rooms_detail: () ->

		enter_room: () ->
			alert('ahahaahh')
				

	class exports.LeftnavView extends Backbone.View

		tagName: 'li'
		className: 'rooms_names'


		render: () ->
			$(@el).html(@model.get("name"))
			@

# 



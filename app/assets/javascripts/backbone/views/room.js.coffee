namespace 'ChatRoom' ,(exports) ->

	class exports.NavigationView extends Backbone.View

		template: ChatRoom.template('home/room')
		create_room_template: ChatRoom.template("home/create_room")
	
		events: {
			'click .new_room'	 :	'new_room'
			'click .create_room' :	'create_room'
			'click .cancel_room' :	'cancel_room'
		}

		render: () ->
			$(@el).html(@template)
			@leftnav = @$('.left-nav')
			@rooms = new exports.Rooms
			@rooms.fetch()


		new_room: () ->
			@$(".dialog")
				.hide()
				.html(@create_room_template())
			@$(".dialog").slideDown()
			

		create_room: ()	->
			@room_name = @$('#room_name').val()
			if @room_name.length != 0
					@$('.dialog').hide()
					@room = new exports.Room
					@room.save({name:@room_name})
			else
				alert("give it a name ,please")		


		cancel_room: () ->
			@$('.dialog').hide()

	class exports.Leftnav extends Backbone.View
		TagName: 'li'
		ClassName: 'rooms_names'
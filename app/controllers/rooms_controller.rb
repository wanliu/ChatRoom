class RoomsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :json, :html

	def create	
		@room = Room.new(:name => params[:name],:onwer => current_user.id)
		@room.members << current_user

		if @room.save
			flash[:notice] = "Successfully created..."
			respond_with @room
		end
	end

	# def create_general_room
	# 	@room = current_user.normalrooms.build(params[:name])
		
	# 	if @room.save
	# 		respond_with(@room)
	# 		flash[:notice] = "Successfully created..."
	# 	end
	# end

	def index
		@room = Room.all

		respond_to do |format|
			format.html
			format.json{ render json: @room }
		end
	end

	# def leave_destroy
	# 	@room = Room.find(params[:id])
	# 	@room.destroy

	# 	respond_to do |format|
	# 		format.html { redirect_to rooms_url }
	# 	end
	# end

	def destroy
		@room = Room.find(params[:id])
		@room.destroy

		respond_to do |format|
			format.html { redirect_to home_url }
			format.json { head :no_content }
		end
	end

	def exit
		@room = Room.find(params[:id])
		@room.members.destroy(current_user)
		respond_with(@room)
	end

	def enter
		@room = Room.find(params[:id])
		@room.members << current_user unless @room.members.exists?(current_user.id)
		respond_with(@room)
  	end

	def members
	    @room = Room.find(params[:id])
	    respond_with(@room.members)
  	end

  	def member
	    @user = User.joins(:rooms).where("users.name = ? and rooms.id = ?", params[:name], params[:id]).first
	    respond_with(@user)

  	end

end

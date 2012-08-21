class Room < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  
  has_many :room_members, :foreign_key => :room_id
  has_many :members, :through => :room_members

  #/rooms/:id/set_admin/:who_id

  def set_admin
  	@who = room_members.find(params[:id])
    @who.roles += ["admin"]
    @who.roles.uniq!
  end

end

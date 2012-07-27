class Room < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :room_members, :foreign_key => :user_id
  has_many :members, :through => :room_members

  def self.at(user)
  	RoomMember.where("user_id = ?", user.id)
  end
end

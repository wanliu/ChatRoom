class RoomMember < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :room
	belongs_to :member, :class_name => "User", :foreign_key => "user_id"
end

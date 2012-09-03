class Room < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :onwer, :member_limit
  
  has_many :room_members, :foreign_key => :room_id
  has_many :members, :through => :room_members

end

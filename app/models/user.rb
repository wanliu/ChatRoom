class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_one :room_member
  has_one :room, :through => :room_member

  attr_accessor :default_room
  @default_room = nil

  def join(room_name)
    room = Room.find_by_name(room_name)
    if room
      r = build_room_member
      r.room = room
      r.save
    end
  end

  def leave
    room = nil
    save
  end
end

#    ________          __     ____                      
#   / ____/ /_  ____ _/ /_   / __ \____  ____  ____ ___ 
#  / /   / __ \/ __ `/ __/  / /_/ / __ \/ __ \/ __ `__ \
# / /___/ / / / /_/ / /_   / _, _/ /_/ / /_/ / / / / / /
# \____/_/ /_/\__,_/\__/  /_/ |_|\____/\____/_/ /_/ /_/   v0.1.0
#                                                            
#
# Copyright 2012 WanLiu, Inc
# Licensed under the Apache License v2.0
# http://www.apache.org/licenses/LICENSE-2.0
#
# author: hysios@gmail.com

require 'digest'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  attr_reader :gravatar

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
    room_member.delete
    save
    reload
  end

  def gravatar
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5::hexdigest(email)}"
  end

  def as_json(*args)
    hash = super
    hash.merge! :gravatar => gravatar
  end
#To stop him from speaking a word
#stuck
  def watch
    
  end
#just nil
  def speak

  end

  def kick
    leave
    redirect_to hall_path
    flash[:notice] = "You\'ve been kicked out of the room"
  end
  #set the room_member to primary_room_member may be a better way
  def mute
    @user.watch
    flash[:notice] = 'You have been muted!!!'
  end
  #the same as the above 
  def dismute
    @user.speak
    flash[:notice] = 'You have been dismuted  :)'
  end

  def set_admin
    
  end
end

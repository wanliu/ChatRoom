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
  ROLES = %w[admin moderator author banned]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname, :email, :password, 
                  :password_confirmation, :remember_me, :muted
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

  #the admin or above action

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

end

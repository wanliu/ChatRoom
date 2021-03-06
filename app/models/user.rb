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

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :authorizations, :dependent => :destroy         

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
                  :uid, :provider, :confirmed_at, :login, :sign_in_status
  # attr_accessible :title, :body

  validates :name, :email, :presence => true
  validates :name, :email, :uniqueness => true
  attr_reader :gravatar

  has_many :room_members
  has_many :rooms, :through => :room_members

  # Virtual attribute for authenticating by either name or email
  # This is in addition to a real persisted field like 'name'
  attr_accessor :default_room, :login
  @default_room = nil

  def gravatar
    "http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5::hexdigest(email)}"
  end

  def as_json(*args)
    hash = super
    hash.merge! :gravatar => gravatar
  end

  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["name = :value OR email = :value", { :value => login }]).first
  end

end

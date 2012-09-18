require 'spec_helper'

describe Room do

  def create_user(name, email)
    User.create!(:name => name, :email => email, :password => 'asdfasdf')

  end

  before :each do
    @bill = create_user('bill gates','bill@gates.com')
    @bob = create_user('bob','bob@mill.com')
    @room1 = Room.create(:name => 'new_rom')
    @channel = Channel.create(:name => 'channel 1')
  end

end

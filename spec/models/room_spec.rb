require 'spec_helper'

describe Room do

  def create_user(email)
    User.create!(:email => email, :password => 'asdfasdf')

  end

  before :each do
    @bill = create_user('bill@gates.com')
    @bob = create_user('bob@mill.com')
    @room1 = Room.create(:name => 'new_rom')
    @channel = Channel.create(:name => 'channel 1')
  end

  it "User can join a Room" do
    @room1.members.should_not include(@bill)
    @bill.join("new_rom")
    @room1.members.reload.should include(@bill)
  end

  it "User can leave a Room" do
    @bill.leave
    @bill.room.should be_nil
  end
end

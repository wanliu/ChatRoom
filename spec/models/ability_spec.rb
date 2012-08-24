require "cancan/matchers"
require "spec_helper"

def create_admin(role)
	User.create!( :role => "admin")
end

@robin = create_admin("admin")

describe "User" do
	describe "ablities" do
		context "when he is an admin" do
			it { robin.should be_able_to(:kick, Room.new)}
			it { robin.should be_able_to(:dismute, User.new)}
			it { robin.should be_able_to(:mute, User.new)}
		end

		context "when he is the room_holder" do

			it { should be_able_to(:set_admin, User.new)}
		end
	end
end
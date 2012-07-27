class CreateRoomMembers < ActiveRecord::Migration
  def change
    create_table :room_members do |t|
      t.integer :room_id, :limit => 11
      t.integer :user_id, :limit => 11
      t.timestamps
    end
  end
end

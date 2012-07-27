class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, :limit => 255
      t.integer :member_limit, :limit => 11
      t.integer :onwer, :limit => 11
      t.timestamps
    end
  end
end

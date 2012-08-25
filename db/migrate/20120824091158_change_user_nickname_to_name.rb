class ChangeUserNicknameToName < ActiveRecord::Migration
  def up
  	rename_column :users, :nickname, :name
  end

  def down
  	rename_column :users, :name, :nickname
  end
end

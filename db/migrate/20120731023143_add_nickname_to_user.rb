class AddNicknameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :nickname, :string , :limit => 25
  end
end

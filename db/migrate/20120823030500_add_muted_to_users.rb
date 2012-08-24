class AddMutedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :muted, :boolean, :default => false
  end
end

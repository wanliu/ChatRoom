class AddSignInStatusToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :sign_in_status, :integer
  end
end

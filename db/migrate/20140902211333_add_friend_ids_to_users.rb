class AddFriendIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :friend_ids, :integer, array: true, default: []
  end
end

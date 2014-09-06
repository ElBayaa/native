class RenameUserFriendIdsToFriendsIds < ActiveRecord::Migration
  def change
    rename_column :users, :friend_ids, :friends_ids
  end
end

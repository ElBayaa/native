class AddCurrentChannelsIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_channels_ids, :integer, array: true, default: []
  end
end

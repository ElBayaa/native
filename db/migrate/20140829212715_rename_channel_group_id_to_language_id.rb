class RenameChannelGroupIdToLanguageId < ActiveRecord::Migration
  def change
    rename_column :channels, :group_id, :language_id
  end
end

class CorrectChannelIndexing < ActiveRecord::Migration
  def change
    remove_index :channels, :name
    add_index :channels, [:name, :language_id], unique: true
  end
end

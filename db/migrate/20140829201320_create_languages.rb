class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, null: false, default: ""

      t.timestamps
    end
    add_index :languages, :name, unique: true
  end
end

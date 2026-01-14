class CreateBookmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.integer :book_id
      t.string :chapter
      t.integer :page
      t.text :note

      t.timestamps
    end
    add_index :bookmarks, :user_id
    add_index :bookmarks, :book_id
  end
end

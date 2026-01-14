class CreateBookshelves < ActiveRecord::Migration[8.0]
  def change
    create_table :bookshelves do |t|
      t.integer :user_id
      t.integer :book_id

      t.timestamps
    end
    add_index :bookshelves, :user_id
    add_index :bookshelves, :book_id
  end
end

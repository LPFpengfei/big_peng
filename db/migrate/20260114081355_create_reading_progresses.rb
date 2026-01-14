class CreateReadingProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :reading_progresses do |t|
      t.integer :user_id
      t.integer :book_id
      t.string :chapter
      t.integer :page

      t.timestamps
    end
    add_index :reading_progresses, :user_id
    add_index :reading_progresses, :book_id
  end
end

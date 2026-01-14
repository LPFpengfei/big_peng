class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :cover_image
      t.string :file_path
      t.integer :category_id
      t.string :source

      t.timestamps
    end
    add_index :books, :category_id
  end
end

class CreateBorrowings < ActiveRecord::Migration[7.0]
  def change
    create_table :borrowings do |t|
      t.integer :user_id
      t.integer :book_id
      t.datetime :borrowed_at
      t.datetime :returned_at
      t.datetime :due_date


      t.timestamps
    end

    add_index :borrowings, [:user_id, :book_id]
    add_index :borrowings, :user_id
    add_index :borrowings, :book_id
    add_foreign_key :borrowings, :users
    add_foreign_key :borrowings, :books, column: :book_id
  end
end

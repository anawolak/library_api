class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :serial, null: false
      t.string :title
      t.string :author
      t.boolean :borrowed_status

      t.timestamps
    end
        
    add_index :books, :serial, unique: true

  end
end

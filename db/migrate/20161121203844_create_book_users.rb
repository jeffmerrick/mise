class CreateBookUsers < ActiveRecord::Migration
  def change
    create_table :book_users do |t|
      t.integer :book_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :book_users, [:book_id, :user_id], unique: true
  end
end

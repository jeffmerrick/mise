class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.timestamps
    end
    remove_column :recipes, :user_id
    add_reference :recipes, :book, index: true
    add_reference :books, :user, index: true
    add_reference :users, :book, index: true
  end
end

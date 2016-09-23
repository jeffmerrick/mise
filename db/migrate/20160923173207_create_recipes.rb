class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.text :author
      t.text :canonical_url
      t.text :cook_time
      t.text :description
      t.text :ingredients
      t.text :instructions
      t.text :name
      t.text :prep_time
      t.text :total_time
      t.text :yield

      t.timestamps null: false
    end
  end
end

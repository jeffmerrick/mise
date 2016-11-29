class AddPinnedToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :pinned, :boolean    
  end
end

class ChangeIngredientsFormat < ActiveRecord::Migration
  def down
    change_column :recipes, :ingredients, :string
  end

  def up
    change_column :recipes, :ingredients, :text
  end
end

class ChangeFieldFormats < ActiveRecord::Migration
  def down
    change_column :recipes, :author, :text
    change_column :recipes, :canonical_url, :text
    change_column :recipes, :cook_time, :text
    change_column :recipes, :ingredients, :text
    change_column :recipes, :name, :text
    change_column :recipes, :prep_time, :text
    change_column :recipes, :total_time, :text
    change_column :recipes, :yield, :text
  end

  def up
    change_column :recipes, :author, :string
    change_column :recipes, :canonical_url, :string
    change_column :recipes, :cook_time, :string
    change_column :recipes, :ingredients, :string
    change_column :recipes, :name, :string
    change_column :recipes, :prep_time, :string
    change_column :recipes, :total_time, :string
    change_column :recipes, :yield, :string
  end
end

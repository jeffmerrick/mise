class CategoriesController < ApplicationController
  def show
    @tag =  ActsAsTaggableOn::Tag.find(params[:id])
    @recipes = Recipe.tagged_with(@tag.name)
  end
end
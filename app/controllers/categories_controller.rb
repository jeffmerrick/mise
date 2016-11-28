class CategoriesController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @categories = ActsAsTaggableOn::Tagging.where(context: "categories", tagger: current_user.books).joins(:tag).select("DISTINCT tags.name, tags.taggings_count, tags.id")
  end

  # GET /tags/1
  def show
    @recipes = Recipe.tagged_with(@category.name)
  end

  # GET /tags/1/edit
  def edit
  end

  # PATCH/PUT /tags/1
  def update
    if @category.update(tag_params)
      redirect_to tags_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @category =  ActsAsTaggableOn::Tag.find(params[:id])
    end

    def tag_params
      params.require(:category).permit(:name)
    end
end
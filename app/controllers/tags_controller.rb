class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @tags = ActsAsTaggableOn::Tagging.where(context: "tags", tagger: current_user.books).joins(:tag).select("DISTINCT tags.name, tags.taggings_count, tags.id")
  end

  # GET /tags/1
  def show
    @recipes = Recipe.tagged_with(@tag.name)
  end

  # GET /tags/1/edit
  def edit
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: 'Tag was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag =  ActsAsTaggableOn::Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

end
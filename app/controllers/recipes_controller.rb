class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :get_taxonomies, only: [:index, :new, :edit]
  before_action :authenticate_user!
  
  # GET /recipes
  def index
    @recipes = current_user.recipes
    @uncategorized_recipes = @recipes.where.not(id: @category_ids)

    if params[:search]
      @recipes = current_user.recipes.search(params[:search]).order("created_at DESC")
    end

  end

  # GET /recipes/1
  def show
  end

  # GET /recipes/new
  def new
    @recipe = current_user.recipes.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  def create
    @current_user = current_user
    @recipe = current_user.recipes.new(recipe_params.merge(user_id: current_user.id))

    unless @recipe.canonical_url.empty?
      require "open-uri"
      recipe_url = @recipe.canonical_url
      begin
        recipe_html_string = open(recipe_url).read

        require "hangry"
        recipe = Hangry.parse(recipe_html_string)

        @recipe.author = recipe.author
        @recipe.cook_time = recipe.cook_time
        @recipe.description = recipe.description
        @recipe.ingredients = recipe.ingredients.join("\n")
        @recipe.instructions = recipe.instructions.gsub(/[^\S\n]/, " ")
        @recipe.name = recipe.name
        @recipe.prep_time = recipe.prep_time
        @recipe.total_time = recipe.total_time
        @recipe.yield = recipe.yield

        #if params[:tag_list]
        #  @current_user.tag(@recipe, on: :tags, with: params[:tag_list], skip_save: true)
        #else
        #  ingredient_list = Array.new
        #  require "ingreedy"
        #  recipe.ingredients.each do |ingredient|
        #    begin
        #      parsed = Ingreedy.parse(ingredient)
        #      ingredient_list.push(parsed.ingredient.to_s.downcase.gsub(/\(.*?\)/, ""))
        #    rescue
        #      # Skip
        #    end
        #  end
        #  @current_user.tag(@recipe, on: :tags, with: ingredient_list, skip_save: true)
        #end
      
        @recipe.book.tag(@recipe, on: :tags, with: params[:tag_list], skip_save: true)
        @recipe.book.tag(@recipe, on: :categories, with: params[:category_list], skip_save: true)
      rescue
        # Need to figure out a better way
      end
    end

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to edit_recipe_path(@recipe), notice: 'Recipe was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    @recipe.book.tag(@recipe, on: :tags, with: params[:recipe][:tag_list], skip_save: true)
    @recipe.book.tag(@recipe, on: :categories, with: params[:recipe][:category_list], skip_save: true)

    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully deleted.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def get_taxonomies
      @categories = ActsAsTaggableOn::Tagging.where(context: "categories", tagger_id: current_user.book, tagger_type: "Book").joins(:tag).select("DISTINCT tags.name, tags.taggings_count")
      @tags = ActsAsTaggableOn::Tagging.where(context: "tags", tagger_id: current_user.book, tagger_type: "Book").joins(:tag).select("DISTINCT tags.name, tags.taggings_count")
      @category_ids = ActsAsTaggableOn::Tagging.where(context: "categories", tagger_id: current_user.book, tagger_type: "Book").collect(&:taggable_id).uniq
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:author, :canonical_url, :cook_time, :description, :ingredients, :instructions, :name, :prep_time, :total_time, :yield)
    end
end

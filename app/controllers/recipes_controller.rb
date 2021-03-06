class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :toggle_pin]
  before_action :get_taxonomies, only: [:index, :new, :edit]
  
  # GET /recipes
  def index
    @recipes = Recipe.where(book: current_user.books)
    @books = current_user.books
    @uncategorized_recipes = @recipes.where.not(id: @category_ids)
    @pinned_recipes = @recipes.where.not(pinned: false)

    if params[:search]
      @recipes = @recipes.search(params[:search]).order("created_at DESC")
    end

  end

  # GET /recipes/1
  def show
  end

  # GET /recipes/new
  def new
    @recipe = current_user.book.recipes.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  def create
    @recipe = current_user.book.recipes.new(recipe_params)
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

        #Automatically add ingredients as tags
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
      rescue
        # Need to figure out a better way
      end
    end

    @recipe.book.tag(@recipe, on: :tags, with: params[:recipe][:tag_list], skip_save: true)
    @recipe.book.tag(@recipe, on: :categories, with: params[:recipe][:category_list], skip_save: true)

    if @recipe.name.blank?
      @recipe.name = "New Untitled Recipe"
    end

    if @recipe.save
      redirect_to edit_recipe_path(@recipe), notice: 'Recipe was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /recipes/1
  def update
    @recipe.book.tag(@recipe, on: :tags, with: params[:recipe][:tag_list], skip_save: true)
    @recipe.book.tag(@recipe, on: :categories, with: params[:recipe][:category_list], skip_save: true)

      if @recipe.update(recipe_params)
        redirect_to @recipe, notice: 'Recipe was successfully updated.'
      else
        render :edit
      end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: 'Recipe was successfully deleted.'

  end

  # POST /recipes/1/toggle_pin
  def toggle_pin
    @recipe.update(pinned: !@recipe.pinned)
    redirect_to :back, notice: "Recipe #{@recipe.pinned? ? "pinned" : "unpinned"}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.where(book: current_user.books).find(params[:id])
    end

    def get_taxonomies
      @categories = ActsAsTaggableOn::Tagging.where(context: "categories", tagger_id: current_user.books, tagger_type: "Book").joins(:tag).select("DISTINCT tags.name, tags.taggings_count")
      @tags = ActsAsTaggableOn::Tagging.where(context: "tags", tagger_id: current_user.books, tagger_type: "Book").joins(:tag).select("DISTINCT tags.name, tags.taggings_count")
      @category_ids = ActsAsTaggableOn::Tagging.where(context: "categories", tagger_id: current_user.books, tagger_type: "Book").collect(&:taggable_id).uniq
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:author, :canonical_url, :cook_time, :description, :ingredients, :instructions, :name, :prep_time, :total_time, :yield)
    end
end

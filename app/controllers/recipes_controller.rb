class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = current_user.recipes
    if params[:search]
      @recipes = current_user.recipes.search(params[:search]).order("created_at DESC")
    else
      @recipes = current_user.recipes
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
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
  # POST /recipes.json
  def create
    @recipe = current_user.recipes.new(recipe_params)
    unless @recipe.canonical_url.empty?
      require 'open-uri'
      recipe_url = @recipe.canonical_url
      recipe_html_string = open(recipe_url).read

      require 'hangry'
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
    end

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to edit_recipe_path(@recipe), notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:author, :canonical_url, :cook_time, :description, :ingredients, :instructions, :name, :prep_time, :total_time, :yield)
    end
end

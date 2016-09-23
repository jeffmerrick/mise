require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  setup do
    @recipe = recipes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recipes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recipe" do
    assert_difference('Recipe.count') do
      post :create, recipe: { author: @recipe.author, canonical_url: @recipe.canonical_url, cook_time: @recipe.cook_time, description: @recipe.description, ingredients: @recipe.ingredients, instructions: @recipe.instructions, name: @recipe.name, prep_time: @recipe.prep_time, total_time: @recipe.total_time, yield: @recipe.yield }
    end

    assert_redirected_to recipe_path(assigns(:recipe))
  end

  test "should show recipe" do
    get :show, id: @recipe
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recipe
    assert_response :success
  end

  test "should update recipe" do
    patch :update, id: @recipe, recipe: { author: @recipe.author, canonical_url: @recipe.canonical_url, cook_time: @recipe.cook_time, description: @recipe.description, ingredients: @recipe.ingredients, instructions: @recipe.instructions, name: @recipe.name, prep_time: @recipe.prep_time, total_time: @recipe.total_time, yield: @recipe.yield }
    assert_redirected_to recipe_path(assigns(:recipe))
  end

  test "should destroy recipe" do
    assert_difference('Recipe.count', -1) do
      delete :destroy, id: @recipe
    end

    assert_redirected_to recipes_path
  end
end

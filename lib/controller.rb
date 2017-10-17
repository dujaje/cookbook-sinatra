require_relative 'cookbook'
require_relative 'view'
require_relative 'recipe'
require_relative 'parsingmethods'

require 'nokogiri'
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
    @parsing = Parsing.new
  end

  def list
    # get the array of recipe names from cookbook
    # output the recipes to the view
    recipes = @cookbook.all
    # recipe_names = []
    # recipes.each do |recipe|
    #   recipe_names << recipe.name.to_s
    # end
    # recipe_prep_time = []
    # recipes.each do |recipe|
    #   recipe_prep_time << recipe.cooking_time.to_s
    # end
    @view.show_list_of_recipes(recipes)
  end

  def create
    # get new recipe name and description from the view
    name = @view.ask_user_for_recipe_name
    ingredients = @view.ask_user_for_recipe_ingredients
    description = @view.ask_user_for_recipe_description
    cooking_time = @view.ask_user_for_cooking_time
    difficulty = @view.ask_user_for_difficulty
    # create new recipe with that name and description
    recipe = Recipe.new(name, description, cooking_time, false, difficulty, ingredients)
    # add that recipe to the cookbook repository
    @cookbook.add_recipe(recipe)
  end

  def destroy
    # get the index of the recipe to be removed
    recipes = @cookbook.all
    @view.show_list_of_recipes(recipes)
    recipe_index = @view.ask_user_for_recipe_number_to_remove - 1
    # associate that index with the recipe to be removed
    # recipe = cookbook.recipes[recipe_index]
    # remove that recipe
    @cookbook.remove_recipe(recipe_index)
    @view.removal_confirmation
  end

  def get_recipes
    # Ask a user for a keyword to search
    ingredient = @view.ask_user_for_key_ingredient
    # Make an HTTP request to the recipe's website with our keyword
    # Parse the HTML document to extract the useful recipe info
    recipe_names_array = @parsing.get_recipe_names(ingredient)
    # Display a list of recipes found to the user
    @view.show_list_of_possible_imports(ingredient, recipe_names_array)
    # Ask the user which number recipe they want to import
    number_returned = @view.ask_user_to_choose_import - 1
    # Make a new HTTP request to fetch more info (description, cooking time, etc.) from the recipe page
    recipe_details_hash = @parsing.get_recipe_full_info(ingredient, number_returned)
    # Add the chosen recipe to the Cookbook
    name = recipe_details_hash[:name]
    description = recipe_details_hash[:description]
    cooking_time = recipe_details_hash[:prep_time]
    difficulty = recipe_details_hash[:difficulty]
    ingredients = recipe_details_hash[:ingredients]
    recipe = Recipe.new(name, description, cooking_time, false, difficulty, ingredients)
    @cookbook.add_recipe(recipe)
  end

  def mark
    # 1. ask the user what task number they wants to mark as complete
    recipes = @cookbook.all
    @view.show_list_of_recipes(recipes)
    tested_index = @view.ask_user_for_tested_number
    # 2. ask the repo to find the task instance with that 'index'
    recipe = @cookbook.find(tested_index)
    # 3. update the task instance to completed true
    recipe.tested!
    # 4. update CSV to completed true
    @cookbook.update_csv
  end

  def use
    # 1. show a list of recipes that could be used
    # 2. ask the user what recipe they would like to use
    recipes = @cookbook.all
    to_use = @view.show_list_of_recipes_to_use(recipes).to_i
    # 3. get information about that recipe
    recipe = @cookbook.find(to_use)
    # 4. print all the recipe info to the view
    @view.recipe_page(recipe)
    # 5. mark recipe as tested
    answer = @view.mark_this_as_tested
    if answer == "Y" || answer == "y"
      recipe.tested!
      @view.testing_confirmation
    else
      @view.no_test_confirmation
    end
  end
end

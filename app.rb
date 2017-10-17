require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

require_relative 'lib/recipe'
require_relative 'lib/cookbook'
require_relative 'lib/view'
require_relative 'lib/parsingmethods'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @csv = 'lib/recipes.csv'
  @recipes = []

  CSV.foreach(@csv) do |row|
    recipe = Recipe.new(row[0], row[1], row[2], row[3], row[4], row[5])
    @recipes << recipe
  end

  erb :index
end

get '/recipe/new' do
  erb :new
end

get '/recipes' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @csv = 'lib/recipes.csv'
  @recipes = []

  CSV.foreach(@csv) do |row|
    recipe = Recipe.new(row[0], row[1], row[2], row[3], row[4], row[5])
    @recipes << recipe
  end

  erb :recipes
end

get '/import' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @recipe = @cookbook.find_by_name(params["name"])
  erb :import
end

post '/import/choose' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @recipe = @cookbook.find_by_name(params["name"])
  @key_ingredient = params["key_ingredient"]
  @parsing = Parsing.new
  @recipe_names_array = @parsing.get_recipe_names(params["key_ingredient"])
  erb :choose_import
end

post '/recipes' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @csv = 'lib/recipes.csv'
  @recipes = []

  @recipes << Recipe.new(params["name".downcase], params["ingredients"], params["prep_time"], false, params["difficulty"], params["method"])

  CSV.foreach(@csv) do |row|
    recipe = Recipe.new(row[0], row[1], row[2], row[3], row[4], row[5])
    @recipes << recipe
  end

  csv_options = { col_sep: ",", force_quotes: true, quote_char: '"' }
  CSV.open(@csv, 'w', csv_options) do |csv|
    @recipes.each do |recipe|
      csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.tested, recipe.difficulty, recipe.ingredients]
    end
  end

  # Make a new HTTP request to fetch more info (description, cooking time, etc.) from the recipe page
  @parsing = Parsing.new
  recipe_chosen_index = params["recipe_array_index"]
  raise
  recipe_details_hash = @parsing.get_recipe_full_info(key_ingredient, recipe_chosen_index)
  # Add the chosen recipe to the Cookbook
  name = recipe_details_hash[:name]
  description = recipe_details_hash[:description]
  cooking_time = recipe_details_hash[:prep_time]
  difficulty = recipe_details_hash[:difficulty]
  ingredients = recipe_details_hash[:ingredients]
  @recipes << Recipe.new(name, description, cooking_time, false, difficulty, ingredients)

  erb :recipes
end

get '/recipes/:name' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @recipe = @cookbook.find_by_name(params["name"])
  erb :recipe
end


get '/remove' do
  @cookbook = Cookbook.new('lib/recipes.csv')
  @recipe = @cookbook.find_by_name(params["name"])
  erb :choose_import
end



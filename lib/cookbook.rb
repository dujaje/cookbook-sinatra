require_relative('recipe.rb')
require 'csv'

class Cookbook
  attr_accessor :recipes
  #---------Data-------------#
  def initialize(csv)
    @csv = csv
    @recipes = []

    CSV.foreach(@csv) do |row|
      recipe = Recipe.new(row[0], row[1], row[2], row[3], row[4], row[5])
      @recipes << recipe
    end
  end

  # --------Instance Methods---------- #
  def all
    # recipe_names = []
    # @recipes.each do |recipe|
    #   recipe_names << "#{recipe.name}"
    # end
    # recipe_names
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    add_to_csv(recipe)
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    remove_from_csv(recipe_index)
  end

  def update_csv
    csv_options = { col_sep: ",", force_quotes: true, quote_char: '"' }
    CSV.open(@csv, 'w', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.tested, recipe.difficulty, recipe.ingredients]
      end
    end
  end

  def add_to_csv(recipe)
    csv_options = { col_sep: ",", force_quotes: true, quote_char: '"' }
    CSV.open(@csv, 'ab', csv_options) do |csv|
      csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.tested, recipe.difficulty, recipe.ingredients]
    end
  end

  def remove_from_csv(recipe_index)
    csv_options = { col_sep: ",", force_quotes: true, quote_char: '"' }
    CSV.open(@csv, 'w', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.tested, recipe.difficulty, recipe.ingredients]
      end
    end
  end

  def find(tested_index)
    return @recipes[tested_index]
  end

  def find_by_name(name)
    return @recipes.find { |r| r.name.downcase.tr(' ', '_') == name }
  end
end


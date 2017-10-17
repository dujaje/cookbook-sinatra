require_relative 'controller'

class View
  def show_list_of_recipes(recipes)
    # recipe_names.each_with_index do |recipe, index|
    #   puts "#{index + 1} - #{recipe} - Cooking"
    # end
    # recipe_names = []
    # recipes.each_with_index do |recipe|
    #   recipe_names << recipe.name.to_s
    # end
    # recipe_prep_time = []
    # recipes.each do |recipe|
    #   recipe_prep_time << recipe.cooking_time.to_s
    # end
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1} - #{recipe.name} - Cooking Time: #{recipe.cooking_time} - Tested? [#{recipe.tested ? "x" : " "}] - Difficulty: #{recipe.difficulty}"
    end
  end

  def show_list_of_recipes_to_use(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1} - #{recipe.name}"
    end
    puts "Which recipe (number) would you like to use today?"
    gets.chomp
  end

  def ask_user_for_recipe_name
    puts "What is the recipe name?"
    gets.chomp
  end

  def ask_user_for_recipe_ingredients
    puts "What is a list of ingredients, seperated by -'s"
    gets.chomp
  end

  def ask_user_for_recipe_description
    puts "What is the recipe method?"
    gets.chomp
  end

  def ask_user_for_difficulty
    puts "How difficult is this recipe?"
    gets.chomp
  end

  def ask_user_for_cooking_time
    puts "How long does this take to make?"
    gets.chomp
  end

  def ask_user_for_recipe_number_to_remove
    puts "Which recipe number would you like to remove?"
    gets.chomp.to_i
  end

  def removal_confirmation
    puts "Recipe removed!"
  end

  def ask_user_for_key_ingredient
    puts "What is the key ingredient in the recipe you want to import"
    gets.chomp
  end

  def show_list_of_possible_imports(ingredient, recipe_names_array)
    puts "Possible recipes to import that include #{ingredient}"
    recipe_names_array.each_with_index do |recipe, index|
      puts "#{index + 1} - #{recipe}"
    end
  end

  def ask_user_to_choose_import
    puts "Which recipe number would you like to import?"
    gets.chomp.to_i
  end

  def ask_user_for_tested_number
    puts "Which recipe number would you like to mark as tested?"
    gets.chomp.to_i
  end

  def recipe_page(recipe)
    puts "****************************************"
    puts "Today you will be cooking #{recipe.name}"
    puts " -- #{recipe.difficulty} - #{recipe.cooking_time} --"
    puts "****************************************"
    puts "INGREDIENTS"
    puts "------"
    ingredients_array = recipe.ingredients.split("-")
    ingredients_array.each do |line|
      puts "- #{line}"
      puts " "
    end
    puts "METHOD"
    puts "------"
    description_array = recipe.description.split(".")
    description_array.each_with_index do |line, index|
      puts "#{index + 1}. #{line}"
      puts " "
    end
  end

  def mark_this_as_tested
    puts "****************************************"
    puts "Would you like to mark this recipe as tested? (Y/N)"
    gets.chomp
  end

  def testing_confirmation
    puts "****************************************"
    puts "We have marked this as a tested recipe!"
  end

  def no_test_confirmation
    puts "****************************************"
    puts "We won't mark this as tested!"
  end
end

require_relative('recipe')
require_relative('cookbook')
require_relative('controller')
require_relative('view')

spagetti = Recipe.new('Spagetti', 'easy to make')
bagel = Recipe.new('Bagel', 'easy to make')
sandwich = Recipe.new('Sandwich', 'easy to make')
cookbook = Cookbook.new('recipes.csv')
controller = Controller.new(cookbook)

cookbook.add_recipe(spagetti)
cookbook.add_recipe(bagel)
cookbook.add_recipe(sandwich)
controller.list
controller.create
controller.list
controller.destroy
controller.list

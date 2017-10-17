class Recipe
  attr_reader :name
  attr_accessor :description, :cooking_time, :tested, :difficulty, :ingredients

  def initialize(name, description, cooking_time, tested = false, difficulty, ingredients)
    @name = name
    @description = description
    @cooking_time = cooking_time
    @tested = (tested == "true")
    @difficulty = difficulty
    @ingredients = ingredients
  end

  def tested!
    @tested = true
  end
end

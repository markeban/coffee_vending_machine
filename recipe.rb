class Recipe

  Ingredient = Struct.new(:base_ingredient_id, :unit_count)

  attr_reader :name, :ingredients

  def initialize(recipe_data)
    @name = recipe_data.fetch(:name)
    @ingredients = recipe_data.fetch(:ingredients).map do |ingredient_data| 
      Ingredient.new(ingredient_data.fetch(:base_ingredient_id), ingredient_data.fetch(:unit_count))
    end
  end
end
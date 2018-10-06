# frozen_string_literal: true

require_relative 'collection_tool.rb'
# RecipeCollection is a collection of recipes
class RecipeCollection
  include CollectionTool

  def initialize(recipes_data)
    @collection = recipes_data.transform_values { |recipe_data| Recipe.new(recipe_data) }
  end

  # Recipe stores instructions for the ingredients and corresponding quanities to make a drink
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
end

# frozen_string_literal: true

require_relative 'recipe.rb'

# RecipeCollection is a collection of recipes
class RecipeCollection
  include Enumerable

  attr_reader :recipes

  def initialize(recipes_data)
    @recipes = recipes_data.transform_values { |recipe_data| Recipe.new(recipe_data) }
  end

  def find(key)
    @recipes.fetch(key)
  end

  def each(&block)
    @recipes.each(&block)
  end
end

require_relative "base_ingredient.rb"

class Inventory
  include Enumerable

  def initialize(base_ingredients_data)
    @base_ingredients = base_ingredients_data.transform_values do |base_ingredient_data|
      BaseIngredient.new(base_ingredient_data)
    end
  end
  
  def find(key)
    @base_ingredients.fetch(key)
  end

  def each(&block)
    @base_ingredients.each(&block)
  end

  def fill_all
    @base_ingredients.each {|id, base_ingredient| base_ingredient.fill }
  end
end

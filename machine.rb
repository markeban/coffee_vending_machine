require_relative "recipe_collection.rb"
require_relative "inventory.rb"

class Machine
  class InvalidSelection < StandardError; end

  def initialize(base_ingredients_data, recipes_data)
    @inventory = Inventory.new(base_ingredients_data)
    @recipe_collection = RecipeCollection.new(recipes_data)
  end

  def take_request
    display_inventory
    display_menu
    make_selection
    take_request
  rescue InvalidSelection => e
    puts e.message
    take_request
  end
  
  private
  
  def display_inventory
    puts "Inventory: "
    @inventory.each do |id, base_ingredient|
      puts "#{base_ingredient.name}, #{base_ingredient.unit_count}" 
    end
  end
  
  def display_menu
    puts "Menu: "
    @recipe_collection.each do |id, recipe|
      puts "#{id}, #{recipe.name}, #{US_dollarize(cost_in_cents(recipe))}, #{drink_in_stock?(recipe)}"
    end
  end

  def US_dollarize(cost_in_cents)
    "$#{sprintf('%.2f', cost_in_cents.to_i/100.0)}"
  end

  def cost_in_cents(recipe)
    recipe.ingredients.reduce(0) do |sum, ingredient|
      sum + (@inventory.find(ingredient.base_ingredient_id).cost * ingredient.unit_count)
    end
  end
  
  def make_selection
    input = gets.chomp
    case input
    when ''
      make_selection
    when 'q', 'Q'
      exit
    when 'r', 'R'
      @inventory.fill_all
    when -> (input) { @recipe_collection.recipes.keys.include?(input.to_i) }
      order_drink(input.to_i)
    else
      raise InvalidSelection, "Invalid selection: #{input}"
    end
  end
  
  def order_drink(id)
    recipe = @recipe_collection.find(id)
    raise InvalidSelection, "Out of stock: #{recipe.name}" unless drink_in_stock?(recipe)

    recipe.ingredients.each do |ingredient|
      @inventory.find(ingredient.base_ingredient_id).use_units(ingredient.unit_count)
    end
    puts "Dispensing: #{recipe.name}"
  end

  def drink_in_stock?(recipe)
    checks = recipe.ingredients.map do |ingredient|
      @inventory.find(ingredient.base_ingredient_id).available_units?(ingredient.unit_count)
    end
    checks.all?
  end
end

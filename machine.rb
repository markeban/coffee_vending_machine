# frozen_string_literal: true

# Machine is a CLI that manages drink orders
class Machine
  class InvalidSelection < StandardError; end

  def initialize(base_ingredients_data:, recipes_data:)
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

  def display_inventory
    display_inventory_items = @inventory.map do |_id, base_ingredient|
      "#{base_ingredient.name},#{base_ingredient.unit_count}"
    end
    display_inventory_items.unshift('Inventory:')
    puts display_inventory_items.join("\n")
  end
  
  def display_menu
    display_menu_items = @recipe_collection.map do |id, recipe|
      "#{id},#{recipe.name},#{dollarize(cost_in_cents(recipe))},#{drink_in_stock?(recipe)}"
    end
    display_menu_items.unshift('Menu:')
    puts display_menu_items.join("\n")
  end
  
  def make_selection
    input = STDIN.gets.chomp
    case input
    when ''
      make_selection
    when 'q', 'Q'
      exit
    when 'r', 'R'
      @inventory.fill_all
    when ->(number_input) { @recipe_collection.find(number_input.to_i) }
      order_drink(input.to_i)
    else
      raise InvalidSelection, "Invalid selection: #{input}"
    end
  end

  private

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

  def dollarize(cost_in_cents)
    "$#{format('%.2f', cost_in_cents.to_i / 100.0)}"
  end

  def cost_in_cents(recipe)
    recipe.ingredients.reduce(0) do |sum, ingredient|
      sum + (@inventory.find(ingredient.base_ingredient_id).cost_in_cents * ingredient.unit_count)
    end
  end
end

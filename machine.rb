class Machine
  class InvalidSelection < StandardError; end

  def initialize(supplies, drink_recipes)
    @inventory = Inventory.new(supplies)
    @drink_recipes = drink_recipes
  end

  def order_coffee(number)
    drink_recipe = @drink_recipes[number - 1]
    puts "Dispensing: #{drink_recipe[:name]}"
    drink_recipe[:proportions].each do |proportion|
      @inventory.reduce_units(proportion[:ingredient], proportion[:units])
    end
  end

  def take_request
    puts "Inventory:"
    # TODO: list ingredients
    puts "Menu"
    # TODO: list menu
    decide_request(gets.chomp)
    take_request
  rescue InvalidSelection => e
    puts e.message
    take_request
  end
  
  private
  
  def decide_request(input)
    case input
    when 'q', 'Q'
      exit
    when 'r', 'R'
      restock
    when -> (input) { input.to_i.between?(1, @drink_recipes.length) }
      order_coffee(input.to_i)
    else
      raise InvalidSelection, "Invalid selection: #{input}"
    end
  end

end


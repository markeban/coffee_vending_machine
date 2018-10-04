class Machine
  class InvalidSelection < StandardError; end

  def initialize(drinks)
    @drinks = drinks
  end

  def order_coffee(number)
    require 'pry'; binding.pry
    drink = @drinks[number - 1]
    puts "Dispensing: #{drink.name}"
    reduce_inventory(drink)
  end

  def restock
    puts "restocking coffee"
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
    when -> (input) { input.to_i.between?(1, @drinks.length) }
      order_coffee(input.to_i)
    else
      raise InvalidSelection, "Invalid selection: #{input}"
    end
  end

  def reduce_inventory(drink)
    drink.drink_requirements.each do |drink_requirement|
      if drink_requirement.quantity > drink_requirement.ingredient.available_units
        raise "not enough available units of #{drink_requirement.ingredient}"
      end

      drink_requirement.ingredient.available_units =- drink_requirement.quantity
    end
  end

end


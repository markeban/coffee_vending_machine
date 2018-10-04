require_relative "machine.rb"
require_relative "drink.rb"
require_relative "drink_requirement.rb"
require_relative "ingredient.rb"


coffee        = Ingredient.new("Coffee", 75),
decaf         = Ingredient.new("Decaf Coffee", 75)
sugar         = Ingredient.new("Sugar", 25)
cream         = Ingredient.new("Cream", 25)
steamed_milk  = Ingredient.new("Steamed Milk", 35)
foamed_milk   = Ingredient.new("Foamed Milk", 35)
espresso      = Ingredient.new("Espresso", 110)
cocoa         = Ingredient.new("Cocoa", 90)
whipped_cream = Ingredient.new("Whipped Cream", 90)

regular_coffee_requirements = [
  DrinkRequirement.new(coffee, 3),
  DrinkRequirement.new(sugar, 1),
  DrinkRequirement.new(cream, 1)
]
regular_coffee = Drink.new("Coffee", regular_coffee_requirements)

decaf_coffee_requirements = [
  DrinkRequirement.new(decaf, 3),
  DrinkRequirement.new(sugar, 1),
  DrinkRequirement.new(cream, 1)
]
decaf_coffee = Drink.new("Decaf Coffee", decaf_coffee_requirements)

machine = Machine.new([
  regular_coffee,
  decaf_coffee
])
machine.take_request


require_relative "machine.rb"
require_relative "drink.rb"
require_relative "drink_requirement.rb"
require_relative "ingredient.rb"


supplies = [
  {
    name: "Coffee",
    cost: 75,
    units: 10
  },
  {
    name: "Decaf Coffee",
    cost: 75,
    units: 10
  },
  {
    name: "Sugar",
    cost: 25,
    units: 10
  },
  {
    name: "Cream",
    cost: 25,
    units: 10
  },
  {
    name: "Steamed Milk",
    cost: 35,
    units: 10
  },
  {
    name: "Foamed Milk",
    cost: 35,
    units: 10
  },
  {
    name: "Espresso",
    cost: 110,
    units: 10
  },
  {
    name: "Cocoa",
    cost: 90,
    units: 10
  },
  {
    name: "Whipped Cream",
    cost: 100,
    units: 10
  }
]

drink_recipes = [
  {
    name: "Coffee",
    proportions: [
      {
        ingredient: "Coffee",
        units: 3
      },
      {
        ingredient: "Sugar",
        units: 1
      },
      {
        ingredient: "Cream",
        units: 1
      }
    ]
  }
]

Machine.new(supplies, drink_recipes)

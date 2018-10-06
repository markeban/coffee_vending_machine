require_relative "machine.rb"

base_ingredients_data = {
  1 => {
    name: "Cocoa",
    cost: 90,
    unit_count: 10
  },
  2 => {
    name: "Coffee",
    cost: 75,
    unit_count: 10
  },
  3 => {
    name: "Cream",
    cost: 25,
    unit_count: 10
  },
  4 => {
    name: "Decaf Coffee",
    cost: 75,
    unit_count: 10
  },
  5 => {
    name: "Espresso",
    cost: 110,
    unit_count: 10
  },
  6 => {
    name: "Foamed Milk",
    cost: 35,
    unit_count: 10
  },
  7 => {
    name: "Steamed Milk",
    cost: 35,
    unit_count: 10
  },
  8 => {
    name: "Sugar",
    cost: 25,
    unit_count: 10
  },
  9 => {
    name: "Whipped Cream",
    cost: 100,
    unit_count: 10
  }
}

recipes_data = {
  1 => {
    name: "Caffe Americano",
    ingredients: [
      {
        base_ingredient_id: 5,
        unit_count: 3
      }
    ]
  },
  2 => {
    name: "Caffe Latte",
    ingredients: [
      {
        base_ingredient_id: 5,
        unit_count: 2
      },
      {
        base_ingredient_id: 7,
        unit_count: 1
      }
    ]
  },
  3 => {
    name: "Caffe Mocha",
    ingredients: [
      {
        base_ingredient_id: 5,
        unit_count: 1
      },
      {
        base_ingredient_id: 1,
        unit_count: 1
      },
      {
        base_ingredient_id: 7,
        unit_count: 1
      },
      {
        base_ingredient_id: 9,
        unit_count: 1
      }
    ]
  },
  4 => {
    name: "Cappuccino",
    ingredients: [
      {
        base_ingredient_id: 5,
        unit_count: 2
      },
      {
        base_ingredient_id: 7,
        unit_count: 1
      },
      {
        base_ingredient_id: 6,
        unit_count: 1
      }
    ]
  },
  5 => {
    name: "Coffee",
    ingredients: [
      {
        base_ingredient_id: 2,
        unit_count: 3
      },
      {
        base_ingredient_id: 8,
        unit_count: 1
      },
      {
        base_ingredient_id: 3,
        unit_count: 1
      }
    ]
  },
  6 => {
    name: "Decaf Coffee",
    ingredients: [
      {
        base_ingredient_id: 4,
        unit_count: 3
      },
      {
        base_ingredient_id: 8,
        unit_count: 1
      },
      {
        base_ingredient_id: 3,
        unit_count: 1
      }
    ]
  }
}

machine = Machine.new(base_ingredients_data, recipes_data)
machine.take_request

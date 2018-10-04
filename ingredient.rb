class Ingredient

  attr_reader :name, :cost_cents, :available_units

  def initialize(name, cost_cents, available_units = 10)
    @name = name
    @cost_cents = cost_cents
    @available_units = available_units
  end

end
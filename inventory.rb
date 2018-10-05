class Inventory

  def initialize(supplies)
    @supplies = supplies.map do |supply|
      @ingredient = Ingredient.new(supplies[:ingredient])
      @units = supplies[:units]
    end
  end

  def reduce_units(ingredient, units)
    # add ids to ingredients, to map them
  end

end
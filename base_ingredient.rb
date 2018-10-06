class BaseIngredient

  attr_accessor :unit_count
  attr_reader :name, :cost

  def initialize(base_ingredient_data)
    @name = base_ingredient_data.fetch(:name)
    @cost = base_ingredient_data.fetch(:cost)
    @unit_count = base_ingredient_data.fetch(:unit_count)
  end

  def available_units?(unit_count_to_use)
    @unit_count >= unit_count_to_use
  end
  
  def use_units(unit_count_to_use)
    raise "insufficient unit_count" unless available_units?(unit_count_to_use)
    
    @unit_count -= unit_count_to_use
  end

  def fill
    @unit_count = 10
  end
end

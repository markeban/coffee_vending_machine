class Drink

  attr_reader :name, :drink_requirements

  def initialize(name, drink_requirements)
    @name = name
    @drink_requirements = drink_requirements
  end

end
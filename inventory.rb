# frozen_string_literal: true

require_relative 'collection_tool.rb'
# Inventory is a collection of base ingredients
class Inventory
  include CollectionTool

  def initialize(base_ingredients_data)
    @collection = base_ingredients_data.transform_values do |base_ingredient_data|
      BaseIngredient.new(base_ingredient_data)
    end
  end

  def fill_all
    @collection.values.each(&:fill)
  end

  # BaseIngredient is used to store the amount of base ingredients
  class BaseIngredient
    MAX_UNIT_COUNT = 10

    attr_accessor :unit_count
    attr_reader :name, :cost_in_cents

    def initialize(base_ingredient_data)
      @name = base_ingredient_data.fetch(:name)
      @cost_in_cents = base_ingredient_data.fetch(:cost_in_cents)
      @unit_count = base_ingredient_data.fetch(:unit_count)
    end

    def available_units?(unit_count_to_use)
      @unit_count >= unit_count_to_use
    end

    def use_units(unit_count_to_use)
      raise 'Insufficient unit_count' unless available_units?(unit_count_to_use)

      @unit_count -= unit_count_to_use
    end

    def fill
      @unit_count =  MAX_UNIT_COUNT
    end
  end
end

# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require_relative '../recipe_collection.rb'

RSpec.describe RecipeCollection do
  let(:recipe_collection) { described_class.new(recipe_data)}
  let(:recipe_data) do
    {
      1 => {
        name: 'Caffe Americano',
        ingredients: [
          {
            base_ingredient_id: 5,
            unit_count: 3
          }
        ]
      },
      2 => {
        name: 'Caffe Latte',
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
      }
    }
  end

  describe '#initialize' do
    it 'create a collection of recipes' do
      first_recipe = [
        {
          base_ingredient_id: 5, unit_count: 3
        }
      ]
      second_recipe = [
        {
          base_ingredient_id: 5, unit_count: 2
        },
        {
          base_ingredient_id: 7, unit_count: 1
        }
      ]
      expect(recipe_collection.find(1).ingredients[0]).to have_attributes(first_recipe[0])
      expect(recipe_collection.find(2).ingredients[0]).to have_attributes(second_recipe[0])
      expect(recipe_collection.find(2).ingredients[1]).to have_attributes(second_recipe[1])
    end
  end
end

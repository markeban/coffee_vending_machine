# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require_relative '../inventory.rb'

RSpec.describe Inventory do
  let(:inventory) { described_class.new(base_ingredient_data) }
  let(:base_ingredient_data) do
    {
      1 => {
        name: 'Coffee',
        cost_in_cents: 75,
        unit_count: 10
      },
      2 => {
        name: 'Cream',
        cost_in_cents: 25,
        unit_count: 10
      },
      3 => {
        name: 'Sugar',
        cost_in_cents: 25,
        unit_count: 10
      }
    }
  end

  describe '#fill_all' do
    context 'base ingredient unit counts are not all maxed out' do
      let(:base_ingredient_data) do
        {
          1 => {
            name: 'Coffee',
            cost_in_cents: 75,
            unit_count: 3
          },
          2 => {
            name: 'Cream',
            cost_in_cents: 25,
            unit_count: 6
          },
          3 => {
            name: 'Sugar',
            cost_in_cents: 25,
            unit_count: 10
          }
        }
      end

      it 'iterates over all base ingredients and calls to fill' do
        inventory.fill_all
        inventory.each do |_id, base_ingredient|
          expect(base_ingredient.unit_count).to eq(Inventory::BaseIngredient::MAX_UNIT_COUNT)
        end
      end
    end
  end
end

RSpec.describe Inventory::BaseIngredient do
  let(:base_ingredient) { described_class.new(base_ingredient_data) }
  let(:base_ingredient_data) do
    {
      name: 'Cream',
      cost_in_cents: 25,
      unit_count: 2
    }
  end

  describe '#available_units?' do
    it 'returns true if enough units exist to dispense' do
      units_requested = 1
      expect(base_ingredient.available_units?(units_requested)).to eq(true)
    end

    it 'returns false if there aren\'t enough units exist to dispense' do
      units_requested = 3
      expect(base_ingredient.available_units?(units_requested)).to eq(false)
    end
  end

  describe '#use_units' do
    it 'subtracts a base ingredient\'s unit_count by argument value' do
      base_ingredient.use_units(1)
      expect(base_ingredient.unit_count).to eq(1)
    end

    it 'raises an error if existing unit_count is greated than units requested' do
      expect { base_ingredient.use_units(3) }.to raise_error(RuntimeError, 'Insufficient unit_count')
    end
  end
end

# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require_relative '../machine.rb'

RSpec.describe Machine do
  let(:machine) do
    described_class.new(
      base_ingredients_data: base_ingredients_data,
      recipes_data: recipes_data
    )
  end
  let(:base_ingredients_data) do
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
        name: 'Decaf Coffee',
        cost_in_cents: 75,
        unit_count: 10
      },
      4 => {
        name: 'Sugar',
        cost_in_cents: 25,
        unit_count: 10
      }
    }
  end
  let(:recipes_data) do
    {
      1 => {
        name: 'Coffee',
        ingredients: [
          {
            base_ingredient_id: 1,
            unit_count: 3
          },
          {
            base_ingredient_id: 2,
            unit_count: 1
          },
          {
            base_ingredient_id: 4,
            unit_count: 1
          }
        ]
      },
      2 => {
        name: 'Decaf Coffee',
        ingredients: [
          {
            base_ingredient_id: 3,
            unit_count: 3
          },
          {
            base_ingredient_id: 2,
            unit_count: 1
          },
          {
            base_ingredient_id: 4,
            unit_count: 1
          }
        ]
      }
    }
  end
  let(:half_empty_machine) do
    described_class.new(
      base_ingredients_data: base_ingredients_half_full_data,
      recipes_data: recipes_data
    )
  end
  let(:base_ingredients_half_full_data) do
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
        name: 'Decaf Coffee',
        cost_in_cents: 75,
        unit_count: 10
      },
      4 => {
        name: 'Sugar',
        cost_in_cents: 25,
        unit_count: 0
      }
    }
  end

  describe '#take_request' do
    before do
      described_class.instance_eval do
        alias_method :take_request_not_stubbed, :take_request
      end
      allow(machine).to receive(:display_inventory)
      allow(machine).to receive(:display_menu)
      allow(machine).to receive(:make_selection)
      allow(machine).to receive(:take_request)
    end

    it 'calls all methods and in order' do
      machine.take_request_not_stubbed
      expect(machine).to have_received(:display_inventory).ordered.once
      expect(machine).to have_received(:display_menu).ordered.once
      expect(machine).to have_received(:make_selection).ordered.once
      expect(machine).to have_received(:take_request).ordered.once
    end
  end

  describe '#display_inventory' do
    let(:inventory_text) do
      <<~INVENTORY
        Inventory:
        Coffee,10
        Cream,10
        Decaf Coffee,10
        Sugar,10
      INVENTORY
    end

    it 'outputs to STDOUT the display interface' do
      machine.display_inventory
      expect { machine.display_inventory }.to output(inventory_text).to_stdout
    end
  end

  describe '#display_menu' do
    let(:menu_test) do
      <<~MENU
        Menu:
        1,Coffee,$2.75,true
        2,Decaf Coffee,$2.75,true
      MENU
    end

    it 'outputs to STDOUT the display interface' do
      machine.display_menu
      expect { machine.display_menu }.to output(menu_test).to_stdout
    end
  end

  describe '#make_selection' do
    context 'when \'\' entered' do
      before do
        described_class.instance_eval do
          alias_method :make_selection_not_stubbed, :make_selection
        end
        allow(machine).to receive(:make_selection)
        allow(STDIN).to receive(:gets).and_return('')
      end

      it 'recursively calls make_selection' do
        machine.make_selection_not_stubbed
        expect(machine).to have_received(:make_selection).once
      end
    end

    context 'when \'q\' entered' do
      before do
        allow(STDIN).to receive(:gets).and_return('q')
      end

      it 'quits the program' do
        expect { machine.make_selection }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(0)
        end
      end
    end

    context 'when \'Q\' entered' do
      before do
        allow(STDIN).to receive(:gets).and_return('Q')
      end

      it 'quits the program' do
        expect { machine.make_selection }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(0)
        end
      end
    end

    context 'when inventory is half empty' do
      context 'when \'r\' entered' do
        before do
          allow(STDIN).to receive(:gets).and_return('r')
        end

        it 'refreshes inventory' do
          max_unit_count = Inventory::BaseIngredient::MAX_UNIT_COUNT
          half_empty_machine.make_selection
          half_empty_machine.inventory.each do |_id, base_ingredient|
            expect(base_ingredient.unit_count).to eq(max_unit_count)
          end
        end
      end

      context 'when \'R\' entered' do
        before do
          allow(STDIN).to receive(:gets).and_return('R')
        end

        it 'refeshes inventory when R entered' do
          max_unit_count = Inventory::BaseIngredient::MAX_UNIT_COUNT
          half_empty_machine.make_selection
          half_empty_machine.inventory.each do |_id, base_ingredient|
            expect(base_ingredient.unit_count).to eq(max_unit_count)
          end
        end
      end
    end

    context 'when correct associated number is chosen' do
      before do
        allow(machine).to receive(:dispense_drink)
        allow(STDIN).to receive(:gets).and_return('1')
      end

      it 'orders a drink' do
        machine.make_selection
        expect(machine).to have_received(:dispense_drink).once
      end
    end

    context 'when input is unexpected value' do
      before do
        described_class.instance_eval do
          alias_method :make_selection_not_stubbed, :make_selection
        end
        allow(machine).to receive(:make_selection)
        allow(STDIN).to receive(:gets).and_return('bad_input')
      end

      it 'outputs an InvalidSelection error' do
        expect { machine.make_selection_not_stubbed }.to output("Invalid selection: bad_input\n").to_stdout
      end
    end
  end

  describe '#dispense_drink' do
    it 'dispenses the correct corresponding drink when ordered' do
      expect(machine.dispense_drink(1)).to eq('Coffee')
    end

    it 'outputs an InvalidSelection error if drink selected is out-of-stock' do
      expect { half_empty_machine.dispense_drink(1) }.to raise_error(Machine::InvalidSelection, 'Out of stock: Coffee')
    end
  end

  describe '#drink_in_stock?' do
    it 'returns true if ingredients exist to dispense drink' do
      first_recipe = machine.recipe_collection.find(1)
      expect(machine.drink_in_stock?(first_recipe)).to eq(true)
    end

    it 'returns false if ingredients don\'t exist to dispense drink' do
      first_recipe = machine.recipe_collection.find(1)
      expect(half_empty_machine.drink_in_stock?(first_recipe)).to eq(false)
    end
  end
end

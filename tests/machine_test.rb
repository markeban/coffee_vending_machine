# frozen_string_literal: true

require 'rspec'
require_relative '../machine.rb'
require_relative '../inventory.rb'
require_relative '../recipe_collection.rb'

RSpec.describe Machine do
  let(:machine) do
    Machine.new(
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

  describe '#display_inventory' do
    it 'outputs to STDOUT the display interface' do
      machine.display_inventory
      inventory_text = <<~INVENTORY
        Inventory:
        Coffee,10
        Cream,10
        Decaf Coffee,10
        Sugar,10
      INVENTORY
      expect { machine.display_inventory }.to output(inventory_text).to_stdout
    end
  end

  describe '#display_menu' do
    it 'outputs to STDOUT the display interface' do
      machine.display_menu
      menu_text = <<~MENU
        Menu:
        1,Coffee,$2.75,true
        2,Decaf Coffee,$2.75,true
      MENU
      expect { machine.display_menu }.to output(menu_text).to_stdout
    end
  end

  describe '#make_selection' do
    # context 'user enters empty string' do
    #   before do
    #     allow(STDIN).to receive(:gets).and_return('')
    #     allow(Machine).to receive(:new).and_return(machine)
    #     allow(machine).to receive(:make_selection).and_call_original
    #   end

    #   after do
    #     allow(STDIN).to receive(:gets).and_return('q')
    #   end

    #   it 'restarts make_selection if input is empty string' do
    #     expect(machine.make_selection).to have_received(:make_selection).twice
    #   end
    # end

    it 'quits the program when q entered' do
      allow(STDIN).to receive(:gets).and_return('q')
      expect { machine.make_selection }.to raise_error(SystemExit) do |error|
        expect(error.status).to eq(0)
      end
    end

    it 'quits the program when Q entered' do
      allow(STDIN).to receive(:gets).and_return('Q')
      expect { machine.make_selection }.to raise_error(SystemExit) do |error|
        expect(error.status).to eq(0)
      end
    end

    it 'dispenses a chosen drink' do
      allow(STDIN).to receive(:gets).and_return('1')
      expect { machine.make_selection }.to output("Dispensing: Coffee\n").to_stdout
    end

    it 'outputs an InvalidSelection error if input is unexpected value' do
      allow(STDIN).to receive(:gets).and_return('bad_input')
      expect { machine.make_selection }.to raise_error(Machine::InvalidSelection, 'Invalid selection: bad_input')
    end

    it 'outputs an InvalidSelection error if drink selected is out-of-stock' do
      allow(STDIN).to receive(:gets).and_return('1')
      expect { 4.times { machine.make_selection } }.to raise_error(Machine::InvalidSelection, 'Out of stock: Coffee')
    end

    it 'refeshes inventory when r entered' do
      # TODO!!!!
      allow(STDIN).to receive(:gets).and_return('1')
      3.times { machine.make_selection }
      expect.to raise_error(Machine::InvalidSelection, 'Out of stock: Coffee')
    end
  end
end

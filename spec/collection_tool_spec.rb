# frozen_string_literal: true

require 'bundler/setup'
require 'rspec'
require_relative '../collection_tool.rb'

RSpec.describe CollectionTool do
  # TODO: move ToyCollection to factory
  class ToyCollection
    include CollectionTool
    def initialize
      @collection = { 1 => 'GameBoy', 2 => 'RC Car' }
    end
  end

  let(:toy_collection) { ToyCollection.new}

  describe '#find' do
    it 'returns the element from numerical key' do
      expect(toy_collection.find(1)).to eq('GameBoy')
    end
  end

  describe '#each' do
    it 'iterates over each element and executes a given block' do
      ids = []
      only_ids = proc { |id, _element| ids << id }
      toy_collection.each(&only_ids)
      expect(ids).to eq([1, 2])
    end
  end

  describe '#map' do
    it 'returns each element and executes a given block' do
      return_only_ids = proc { |id, _element| id }
      expect(toy_collection.map(&return_only_ids)).to eq([1, 2])
    end
  end
end

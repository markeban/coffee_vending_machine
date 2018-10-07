# frozen_string_literal: true

# CollectionTool is used for common operations on a collection
module CollectionTool
  def find(key)
    @collection.fetch(key)
  rescue KeyError
    false
  end

  def each(&block)
    @collection.each(&block)
  end

  def map(&block)
    @collection.map(&block)
  end
end

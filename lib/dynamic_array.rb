require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    index >= @length ? raise("index out of bounds") : @store[index]
  end

  # O(1)
  def []=(index, value)
    resize! if index >= @capacity

    @store[index] = value
    @length += 1
  end

  # O(1)
  def pop
    @length -= 1
    val = @store[@length]
    @store[@length] = nil
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    @length += 1
    resize! if @length > @capacity
    @store[@length - 1] = val
  end

  # O(n): has to shift over all the elements.
  def shift
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
  end

  protected

  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    new_array = StaticArray.new(@capacity)
    i = 0
    while i < @capacity/2
      new_array[i] = @store[i]
      i += 1
    end

    @store = new_array
  end
end

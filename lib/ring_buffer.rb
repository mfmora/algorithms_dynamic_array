require 'byebug'
require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @length = 0
    @capacity = 8
    @start_idx = 0
    @store = StaticArray.new(@capacity)
  end

  # O(1)
  def [](index)
    idx = (@start_idx + index) % @capacity
    check_index(idx)
    @store[idx]
  end

  # O(1)
  def []=(index, val)
    idx = (@start_idx + index) % @capacity
    @store[idx] = val
    @length += 1
  end

  # O(1)
  def pop
    check_index(@length - 1)
    index = (@start_idx - 1) % @length
    @length -= 1
    val = @store[index]
    @store[index] = nil
    val
  end

  # O(1) ammortized
  def push(val)
    @length += 1
    resize! if @length > @capacity
    index = (@start_idx - 1) % @length
    @store[index] = val
  end

  # O(1)
  def shift
    val = @store[@start_idx]
    @start_idx += 1
    val
  end

  # O(1) ammortized
  def unshift(val)
    
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise("index out of bounds") if index >= @length || index < 0
  end

  def resize!
    @old_capacity = @capacity
    @capacity *= 2
    new_array = StaticArray.new(@capacity)
    i = 0
    while i < @old_capacity
      new_array[i] = @store[i]
      i += 1
    end

    @store = new_array
  end
end

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
    check_index(index)
    idx = (@start_idx + index) % @capacity
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
    check_index((@start_idx - 1 + length) % @capacity)
    index = (@start_idx - 1 + length) % @capacity
    @length -= 1
    val = @store[index]
    @store[index] = nil
    val
  end

  # O(1) ammortized
  def push(val)
    @length += 1
    resize! if @length > @capacity
    index = (@start_idx - 1 + length) % @capacity
    @store[index] = val
  end

  # O(1)
  def shift
    check_index(@length - 1)
    val = @store[@start_idx]
    @store[@start_idx] = nil
    @start_idx += 1
    @length -= 1
    val
  end

  # O(1) ammortized
  def unshift(val)
    @length += 1
    resize! if @length > @capacity
    index = (@start_idx - 1) % @capacity
    @start_idx = index
    @store[index] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise("index out of bounds") if index >= @length || @length <= 0
  end

  def resize!
    @old_capacity = @capacity
    @capacity *= 2
    new_array = StaticArray.new(@capacity)
    i = @start_idx
    @old_capacity.times do |index|
      new_array[index] = @store[i]
      i = (i + 1) % @old_capacity
    end
    @start_idx = 0
    @store = new_array
  end
end

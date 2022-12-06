require 'set'
require_relative '../lib/utils'

class Day6
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 6
    @input = read_input.chomp.chars
  end

  def part_1
    (0..input.length-4).each do |idx|
      if Set.new(input[idx..idx+3]).length == 4
        return idx + 4
      end
    end
  end

  def part_2
    (0..input.length-14).each do |idx|
      if Set.new(input[idx..idx+13]).length == 14
        return idx + 14
      end
    end
  end

  private

end

### MAIN

solver = Day6.new
puts solver.part_1
puts solver.part_2
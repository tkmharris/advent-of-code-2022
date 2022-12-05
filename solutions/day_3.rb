require_relative '../lib/utils'
require 'set'

class Day3
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 3
    @input = read_input
  end

  def part_1
    rucksacks = @input.split.map do |contents|
      half = contents.length / 2
      [contents[...half], contents[half...]]
    end
  
    rucksacks.map do |rucksack| 
      priority(common_item(rucksack))
    end.
      sum
  end
  
  def part_2
    rucksack_groups = @input.split.each_slice(3).to_a
    
    rucksack_groups.map do |group| 
      priority(common_item(group))
    end.
      sum
  end

  private

  ITEMS = ('a'..'z').to_a + ('A'..'Z').to_a

  def common_item(item_group)
    intersection = item_group.first.chars.to_set
    item_group.each do |item|
      intersection = intersection.intersection(item.chars.to_set)
    end
    
    intersection.first
  end
  
  def priority(item)
    ITEMS.index(item) + 1
  end
end

### MAIN
solver = Day3.new
puts solver.part_1
puts solver.part_2
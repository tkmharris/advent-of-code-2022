require 'set'

### constants
ITEMS = ('a'..'z').to_a + ('A'..'Z').to_a

### helpers

def data
  input_file = 'input.txt'
  data = File.read(input_file)
end

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

### problems

def part_1
  rucksacks = data.split.map do |contents|
    half = contents.length / 2
    [contents[...half], contents[half...]]
  end

  rucksacks.map do |rucksack| 
    priority(common_item(rucksack))
  end.
    sum
end

def part_2
  rucksack_groups = data.split.each_slice(3).to_a
  rucksack_groups.map do |group| 
    priority(common_item(group))
  end.
    sum
end

### MAIN

puts part_1
puts part_2


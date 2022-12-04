require 'set'

### constants

PATTERN = /(?<begin1>\d+)\-(?<end1>\d+)/

### helpers

class Span
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def contains(other)
    (self.start <= other.start) && (other.finish <= self.finish)
  end

  def overlaps(other)
    !((self.finish < other.start) || (other.finish < self.start))
  end
end

### helpers

def data
  input_file = 'input.txt'
  data = File.read(input_file)
end

### problems

def part_1
  span_pairs = data.split.map do |line|
    line.scan(PATTERN).map { |match| match.map(&:to_i) }
  end

  span_pairs.count do |pair|
    span1 = Span.new(*pair[0])
    span2 = Span.new(*pair[1])
    
    span1.contains(span2) || span2.contains(span1)
  end
end

def part_2
  span_pairs = data.split.map do |line|
    line.scan(PATTERN).map { |match| match.map(&:to_i) }
  end

  span_pairs.count do |pair|
    span1 = Span.new(*pair[0])
    span2 = Span.new(*pair[1])
    
    span1.overlaps(span2)
  end
end

### MAIN

puts part_1
puts part_2


require_relative '../lib/utils'

class Day4
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 4
    @input = read_input
  end

  def part_1
    span_pairs = input.split.map do |line|
      line.scan(SPAN_PATTERN).map { |match| match.map(&:to_i) }
    end
  
    span_pairs.count do |pair|
      span1 = Span.new(*pair[0])
      span2 = Span.new(*pair[1])
      
      span1.contains(span2) || span2.contains(span1)
    end
  end
  
  def part_2
    span_pairs = input.split.map do |line|
      line.scan(SPAN_PATTERN).map { |match| match.map(&:to_i) }
    end
  
    span_pairs.count do |pair|
      span1 = Span.new(*pair[0])
      span2 = Span.new(*pair[1])
      
      span1.overlaps(span2)
    end
  end

  private

  SPAN_PATTERN = /(?<begin1>\d+)\-(?<end1>\d+)/

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
end

### MAIN

solver = Day4.new
puts solver.part_1
puts solver.part_2

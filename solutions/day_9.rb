require_relative '../lib/utils'
require 'set'

class Day9
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 9
    @input = read_input.split("\n")
  end

  def part_1
    head = Knot.new(Vec.new(0,0), nil)
    tail = Knot.new(Vec.new(0,0), head)

    tail_visitied = Set.new([tail.position])

    instructions.each do |instruction|
      instruction.distance.times do 
        head.position += instruction.direction
        tail.position += follower_move(tail)
        tail_visitied << tail.position
      end
    end
    
    tail_visitied.length
  end

  def part_2
    knots = []
    10.times { knots << Knot.new(Vec.new(0,0), knots.last) }

    tail_visitied = Set.new([knots.last.position])

    instructions.each do |instruction|
      instruction.distance.times do 
        knots.each do |knot|
          if !knot.parent
            knot.position += instruction.direction
          else
            knot.position += follower_move(knot)
          end
        end

        tail_visitied << knots.last.position
      end
    end

    tail_visitied.length
  end

  private

  class Vec
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      x == other.x && y == other.y
    end

    def eql?(other)
      self == other
    end

    def hash
      [x, y].hash
    end
    
    def +(other)
      Vec.new(x + other.x, y + other.y)
    end

    def -(other)
      Vec.new(x - other.x, y - other.y)
    end
  end

  class Knot
    attr_accessor :position, :parent
    def initialize(position, parent)
      @position = position
      @parent = parent
    end
  end

  class Instruction
    attr_reader :direction, :distance
    def initialize(direction, distance)
      @direction = direction
      @distance = distance
    end
  end

  MOVES = {
    R: Vec.new(1,0), L: Vec.new(-1,0), U: Vec.new(0,1), D: Vec.new(0,-1)
  }

  def self.parse(move_input)
    m = /(?<direction>[A-Z]{1}) (?<distance>\d+)/.match(move_input)
    
    Instruction.new(
      MOVES[m[:direction].to_sym],
      m[:distance].to_i
    )
  end

  def instructions
    input.map { |move_input| self.class.parse(move_input) }
  end

  def follower_move(child)
    diff = child.parent.position - child.position 

    if [diff.x.abs, diff.y.abs].max <= 1
      Vec.new(0, 0)
    else 
      Vec.new(sign(diff.x), sign(diff.y))
    end
  end

  def sign(x)
    return 0 if x == 0

    x > 0 ? 1 : -1
  end
end

### MAIN
solver = Day9.new
puts solver.part_1
puts solver.part_2
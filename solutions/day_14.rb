require_relative '../lib/utils'
require 'pry'
class Day14
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 14
    @input = read_input.split("\n")
  end

  def part_1
    grid = Grid.build_grid(input)
    settled_count = 0

    while true
      sand = Sand.new(grid)
      if sand.fall
        settled_count += 1
        grid.grid[sand.position] = :sand
      else
        break
      end
    end

    return settled_count
  end

  def part_2
    grid = Grid.build_grid(input)
    settled_count = 0

    while !grid.grid[Vec.new(500, 0)]
      sand = Sand.new(grid)
      sand.fall_to_floor
      grid.grid[sand.position] = :sand
      settled_count += 1
    end

    return settled_count
  end

  private

  class Grid
    include AoCUtils
    attr_accessor :grid, :lowest_stone
    def initialize
      @grid = {}
      @lowest_stone = nil
    end 

    def self.build_grid(input)
      grid = Grid.new
      input.each {|input_line| grid.add_stones(input_line) } 

      grid.lowest_stone = grid.grid.filter { |vec, material| material == :stone }.
      map { |vec, material| vec.y }.
      max

      grid
    end

    def add_stones(input_line)
      points = input_line.split(" -> ").map do |pair_str|
        xy = pair_str.split(",").map(&:to_i)
        Vec.new(*xy)
      end
  
      points[...-1].each_with_index do |point, index|
        start = point ; finish = points[index + 1]
        if start.x == finish.x
          low, high = [start.y, finish.y].sort
          (low..high).each do |y|
            grid[Vec.new(start.x, y)] = :stone
          end
        elsif start.y == finish.y
          low, high = [start.x, finish.x].sort
          (low..high).each do |x|
            grid[Vec.new(x, start.y)] = :stone
          end
        end
      end
    end
  end

  class Sand
    include AoCUtils
    attr_reader :grid
    attr_accessor :position, :settled
    def initialize(grid, position: Vec.new(500, 0))
      @position = position
      @settled = false
      @grid = grid
    end

    def move
      directions = [
        Vec.new(0, 1), Vec.new(-1, 1), Vec.new(1, 1)
      ]
      
      directions.each do |direction|
        if !grid.grid[self.position + direction]
          self.position = self.position + direction
          return
        end
      end
      self.settled = true
    end

    def fall
      while true
        self.move
        if settled
          return true
        elsif lost_to_the_void?
          return false
        end
      end
    end

    def fall_to_floor
      while true
        self.move
        if settled || hits_the_floor?
          break
        end
      end
    end

    def lost_to_the_void?
      position.y >= grid.lowest_stone
    end

    def hits_the_floor?
      position.y == grid.lowest_stone + 1
    end 
  end
end

### MAIN
solver = Day14.new
puts solver.part_1
puts solver.part_2
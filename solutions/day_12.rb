require_relative '../lib/utils'
require 'pry'

class Day12
  include AoCUtils

  attr_reader :day, :grid, :width, :height
  def initialize
    @day = 12
    @grid = read_input.split("\n").map(&:chars)
    @width = @grid.first.length
    @height = @grid.length
  end

  def part_1
    start = find_start
    finish = find_end
    queue = [start]
    visited = {start => 0}

    while true
      current = queue.shift
      current_elevation = elevation(grid[current.y][current.x])
      neighbours(current).each do |neighbour|
        if (elevation(grid[neighbour.y][neighbour.x]) <= current_elevation + 1) && !visited[neighbour]
          visited[neighbour] = visited[current] + 1
          if neighbour == finish
            return visited[neighbour]
          else
            queue << neighbour
          end
        end
      end
    end
  end

  def part_2
    start = find_end
    queue = [start]
    visited = {start => 0}

    while true
      current = queue.shift
      current_elevation = elevation(grid[current.y][current.x])
      neighbours(current).each do |neighbour|
        if (elevation(grid[neighbour.y][neighbour.x]) >= current_elevation - 1) && !visited[neighbour]
          visited[neighbour] = visited[current] + 1
          if elevation(grid[neighbour.y][neighbour.x]) == 0
            return visited[neighbour]
          else
            queue << neighbour
          end
        end
      end
    end
  end

  def elevation(letter)
    if letter == 'S'
      0
    elsif letter == 'E'
      25
    else
      ('a'..'z').to_a.index(letter)
    end
  end

  def neighbours(vec)
    directions = [
      Vec.new(1,0), Vec.new(-1,0), Vec.new(0,1), Vec.new(0,-1)
    ]
    
    directions.map { |dir| vec + dir }.filter do |neighbour|
      (0 <= neighbour.x)  && (neighbour.x < self.width) && (0 <= neighbour.y) && (neighbour.y < self.height)
    end
  end

  def find_start
    grid.each_with_index do |row, index|
      if row.index('S')
        return Vec.new(row.index('S'), index)
      end
    end
  end

  def find_end
    grid.each_with_index do |row, index|
      if row.index('E')
        return Vec.new(row.index('E'), index)
      end
    end
  end

  private 


end

### MAIN
solver = Day12.new
puts solver.part_1
puts solver.part_2
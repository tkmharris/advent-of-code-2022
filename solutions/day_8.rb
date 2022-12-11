require_relative '../lib/utils'

class Day8
  include AoCUtils

  attr_reader :day, :input
  attr_accessor :forest, :visible_trees
  def initialize
    @day = 8
    @input = read_input.split("\n")
    @forest = @input.map { |row| row.chars.map(&:to_i) }
    @visible_trees = @forest.map do |row|
      row.map { |tree_height| false }
    end
  end

  def part_1
    forest = @input.map { |row| row.chars.map(&:to_i) }
    visible_trees = forest.map do |row|
      row.map { |tree_height| false }
    end

    4.times do
      mark_visible_along_row(forest: forest, visible_trees: visible_trees)
      mark_visible_along_column(forest: forest, visible_trees: visible_trees)

      forest = rotate(forest)
      visible_trees = rotate(visible_trees)
    end
    
    visible_trees.sum do |row|
      row.sum do |visible|
        visible ? 1 : 0
      end
    end
  end

  def part_2
    forest = @input.map { |row| row.chars.map(&:to_i) }

    visible_counts = (0...forest.length).map do |row_idx|
      (0...forest.length).map do |col_idx|
        num_visible_from(forest: forest, row_idx: row_idx, col_idx: col_idx)
      end
    end

    visible_counts.map(&:max).max
  end

  private

  def rotate(matrix)
    matrix.transpose.map(&:reverse)
  end

  def mark_visible_along_row(forest:, visible_trees:)
    forest.each_with_index do |row, i|
      current_max_height = -1
      row.each_with_index do |tree_height, j|
        if tree_height > current_max_height
          visible_trees[i][j] = true
          current_max_height = tree_height
        end
      end
    end 
  end

  def mark_visible_along_column(forest:, visible_trees:)
    visible_trees = visible_trees.transpose

    forest.transpose.each_with_index do |row, i|
      current_max_height = -1
      row.each_with_index do |tree_height, j|
        if tree_height > current_max_height
          visible_trees[i][j] = true
          current_max_height = tree_height
        end
      end
    visible_trees = visible_trees.transpose
    end 
  end

  def num_visible_from(forest:, row_idx:, col_idx:)

    size = forest.length
    height = forest[row_idx][col_idx]
    
    visible_left = 0 
    (0...col_idx).each do |idx|
      visible_left += 1
      if forest[row_idx][col_idx - idx - 1] >= height
        break
      end
    end

    visible_right = 0 
    (col_idx+1...size).each do |idx|
      visible_right += 1
      if forest[row_idx][idx] >= height
        break
      end
    end

    visible_up = 0 
    (0...row_idx).each do |idx|
      visible_up += 1
      if forest[row_idx - idx - 1][col_idx] >= height
        break
      end
    end

    visible_down = 0 
    (row_idx+1...size).each do |idx|
      visible_down += 1
      if forest[idx][col_idx] >= height
        break
      end
    end

    visible_left * visible_right * visible_up * visible_down
  end
end

### MAIN
solver = Day8.new
puts solver.part_1
puts solver.part_2
require_relative '../lib/utils'

class Day1
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 1
    @input = read_input
  end

  def part_1
    elf_sums.max
  end

  def part_2
    elf_sums.sort.reverse[...3].sum
  end

  private

  def elf_sums
    input.split(/\n\n/).map do |elf_data|
      elf_data.split.map(&:to_i).sum
    end
  end

end

### MAIN

solver = Day1.new
puts solver.part_1
puts solver.part_2
require_relative '../lib/utils'

class Day11
  include AoCUtils

  attr_reader :day
  attr_accessor :monkeys
  def initialize
    @day = 11
    @monkeys = parse_input(read_input).map do |monkey|
      [monkey.number, monkey]
    end.to_h
  end

  def part_1
    20.times do
      play_round(monkeys)
    end

    inspections_product_output(monkeys)
  end

  def part_2
    10000.times do
      play_round(monkeys, worry_cap: worry_cap(monkeys), extra_worry: true)
    end

    inspections_product_output(monkeys)
  end

  private

  def parse_input(input)
    matches = input.
      to_enum(:scan, Monkey.monkey_matcher).
      map { Regexp.last_match }

    matches.map { |match| Monkey.new(match) }
  end

  def play_round(monkeys, worry_cap: nil, extra_worry: false)
    monkeys.each do |_, monkey|
      to_remove = []
      monkey.items.each do |item|
        throw_to = monkey.inspect(item, extra_worry: extra_worry)
        if worry_cap
          item.worry_level = item.worry_level % worry_cap
        end
        to_remove << item 
        monkeys[throw_to].items << item
      end

      to_remove.each { |item| monkey.items.delete(item) } 
    end
  end

  def inspections_product_output(monkeys)
    ranked_inspections = monkeys.values.map do
      |monkey| monkey.inspections
    end.sort.reverse
    
    ranked_inspections[0] * ranked_inspections[1]
  end

  def worry_cap(monkeys)
    monkeys.values.map {|monkey| monkey.divisor }.inject(:*)
  end

  class Item
    attr_accessor :worry_level
    def initialize(worry_level)
      @worry_level = worry_level
    end
  end

  class Monkey
    attr_reader :number, 
                :operation, 
                :divisor, 
                :true_monkey, 
                :false_monkey
    attr_accessor :items,
                  :inspections
    def initialize(match)
      @number = match[:monkey_number].to_i
      @items = Monkey.starting_items_matcher(match[:items]).map do |worry_level|
        Item.new(worry_level)
      end
      @operation = match[:operation].gsub('old', 'item.worry_level').gsub('new', 'item.worry_level')
      @divisor = match[:divisor].to_i
      @true_monkey = match[:true_monkey].to_i
      @false_monkey = match[:false_monkey].to_i
      @inspections = 0
    end

    def inspect(item, extra_worry:)
      eval(self.operation) # updates item.worry_level
      if !extra_worry
        item.worry_level /= 3
      end
      
      self.inspections += 1

      if item.worry_level % self.divisor == 0
        self.true_monkey
      else
        self.false_monkey
      end
    end

    private

    def self.monkey_matcher
      %r{
        Monkey\s(?<monkey_number>\d+):
        \n\s+Starting\sitems:(?<items>[^\n]+)
        \n\s+Operation:\s(?<operation>[^\n]+)
        \n\s+Test:\sdivisible\sby\s(?<divisor>\d+)
        \n\s+If\strue:\sthrow\sto\smonkey\s(?<true_monkey>\d+)
        \n\s+If\sfalse:\sthrow\sto\smonkey\s(?<false_monkey>\d+)
      }x
    end

    def self.starting_items_matcher(items)
      items.split.map(&:strip).map(&:to_i)
    end
  end
end

### MAIN
solver = Day11.new
puts solver.part_1
puts solver.part_2
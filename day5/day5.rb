### constants

INSTRUCTION_PATTERN = /move (?<number>\d+) from (?<from>\d+) to (?<to>\d+)/

### helpers

class Instruction
  attr_reader :number, :from, :to

  def initialize(str)
    m = INSTRUCTION_PATTERN.match(str)

    @number = m[:number].to_i
    @from = m[:from].to_i
    @to = m[:to].to_i
  end
end

class Storage
  attr_accessor :stacks
  
  def initialize
    @stacks = (1..9).map {|i| [i, []] }.to_h
  end
end

def data
  input_file = 'input.txt'
  data = File.readlines(input_file).map(&:chomp)
end

def instructions
  instructions = []
  data.each do |line|
    if INSTRUCTION_PATTERN.match(line)
      instructions << Instruction.new(line)
    end
  end

  instructions
end

def initial_storage
  
  input = []
  data.each do |line|
    if !INSTRUCTION_PATTERN.match(line)
      input << line
    else
      break
    end
  end

  storage = Storage.new

  (1..9).each do |num|
    idx = input[-2].index(num.to_s)
    
    input[...-2].each do |line|
      if line[idx] != ' '
        storage.stacks[num] << line[idx].to_sym
      end
    end

    storage.stacks[num].reverse!
  end

  storage
end

### problems

def part_1
  storage = initial_storage

  instructions.each do |instruction|
    instruction.number.times do
      break unless (storage.stacks[instruction.from] != [])

      box = storage.stacks[instruction.from].pop
      storage.stacks[instruction.to] << box
    end
  end

  (1..9).map do |num|
    storage.stacks[num].last.to_s
  end.
    join
end

def part_2
  storage = initial_storage

  instructions.each do |instruction|
    boxes = []
    instruction.number.times do
      break unless (storage.stacks[instruction.from] != [])

      boxes << storage.stacks[instruction.from].pop
    end

    storage.stacks[instruction.to] += (boxes.reverse)
  end

  (1..9).map do |num|
    storage.stacks[num].last.to_s
  end.
    join
end

### MAIN

puts part_1
puts part_2


require_relative '../lib/utils'

class Day10
  include AoCUtils

  attr_reader :day, :instructions
  def initialize
    @day = 10
    @input = read_input.split("\n")
    @instructions = @input.map { |line| Instruction.new(line) }
  end

  def part_1
    cpu = CPU.new

    instructions.each do |instruction|
      cpu.send(instruction.method, instruction.arg)
    end

    cycles_of_interest = [20, 60, 100, 140, 180, 220]
    signal_strengths = cycles_of_interest.map do |cycle|
      cpu.signal[cycle - 1]
    end

    signal_strengths.sum
  end

  def part_2
    cpu = CPU.new

    instructions.each do |instruction|
      cpu.send(instruction.method, instruction.arg)
    end

    cpu.crt.output
  end

  private

  class CPU
    attr_accessor :cycles, :register, :signal, :crt
    def initialize(cycles: 0, register: 1, signal: [], crt: CRT.new)
      @cycles = cycles
      @register = register
      @signal = signal
      @crt = crt
    end

    def signal_strength
      self.cycles * self.register 
    end

    def noop(x) # takes an argument so we can use send in the main function
      update_crt
      self.cycles += 1
      self.signal << signal_strength
    end

    def addx(x)
      2.times do
        update_crt
        self.cycles += 1
        self.signal << signal_strength
      end
      self.register += x
    end

    def update_crt
      self.crt.next_pixel(self.cycles, self.register)
    end
  end

  class CRT
    
    attr_accessor :stream
    def initialize
      @stream = []
    end

    def sprite_locations(register)
      [
        (register - 1) % 40,
        register % 40,
        (register + 1) % 40
      ]
    end

    def next_pixel(cycle, register)
      self.stream << (sprite_locations(register).include?(cycle % 40) ? '#' : '.')
    end

    def output
      self.stream.each_slice(40).map(&:join).join("\n")
    end
  end

  class Instruction
    attr_reader :method, :arg
    def initialize(instruction)
      @method, @arg = Instruction.parse(instruction)
    end

    def self.parse(instruction)
      if instruction[..3] == 'noop'
        [:noop, nil]
      elsif instruction[..3] == 'addx'
        [:addx, instruction[5..].to_i]
      else
        raise ArgumentError.new
      end
    end
  end
end

### MAIN
solver = Day10.new
puts solver.part_1
puts solver.part_2
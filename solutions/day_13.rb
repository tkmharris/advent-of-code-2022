require_relative '../lib/utils'

class Day13
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 13
    @input = read_input
  end

  def part_1
    pairs = read_packet_pairs(input)

    pairs.map.with_index do |pair, index|
      pair.left < pair.right ? (index + 1) : 0
    end.
      sum
  end

  def part_2
    divider_packets = [
      Packet.new([[2]]), Packet.new([[6]])
    ]
    packets = read_all_packets(input) + divider_packets

    packets.sort!
    
    (packets.index(divider_packets[0]) + 1) * (packets.index(divider_packets[1]) + 1)
  end

  private
  InputPair = Struct.new(:left, :right)
  
  def read_packet_pairs(input)
    input.split("\n\n").map do |pair_line|
      first, second = pair_line.split("\n")
      InputPair.new(
        Packet.new(eval(first)), Packet.new(eval(second))
      )
    end
  end

  def read_all_packets(input)
    input.split(/[\n]+/).map { |line| Packet.new(eval(line)) }
  end
  
  class Packet
    include Comparable

    attr_reader :packet
    def initialize(packet)
      @packet = packet
    end

    def ==(other)
      self.packet == other.packet
    end

    def <=>(other)
      case Packet.compare(self.packet, other.packet)
      when :left then -1
      when :same then 0
      when :right then 1
      end
    end
    
    def self.compare(left, right)
      return :same if (left == [] && right == [])
      return :left if (left == [] && right != [])
      return :right if (left != [] && right == [])

      if !(left.is_a?(Array)) && !(right.is_a?(Array))
        case left <=> right
        when -1 then :left 
        when 0 then :same
        when 1 then :right
        end

      else
        left = Array(left) ; right = Array(right)
        compare_first = self.compare(left.first, right.first)
        return compare_first if compare_first != :same
        
        return self.compare(left[1..], right[1..])
      end
    end
  end
end

### MAIN
solver = Day13.new
puts solver.part_1
puts solver.part_2
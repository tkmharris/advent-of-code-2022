require_relative '../lib/utils'
require 'set'
require 'pry'

class Day15
  include AoCUtils

  attr_reader :day, :sensors, :beacon_positions
  def initialize
    @day = 15
    @sensors = read_input.split("\n").map do |input_line|
      Sensor.new(*parse(input_line))
    end
    @beacon_positions = @sensors.map { |sensor| sensor.beacon_position }
  end

  def part_1
    row = 2000000

    sensor_ranges = sensors.map do |sensor| 
      sensor.beacon_range_ruled_out_in_row(row)
    end.filter { |range| range }
    beacons_in_row = beacon_positions.filter do |position|
      position.y == row
    end
      .map { |position| position.x }.uniq
    
    start = sensors.map { |sensor| sensor.position.x - sensor.beacon_distance }.min
    finish = sensors.map { |sensor| sensor.position.x + sensor.beacon_distance }.max
    
    impossible_positions = 0
    beacons_encountered = 0
    position = start
    while position <= finish
      moved = false
      sensor_ranges.each do |range|
        if beacons_in_row.include?(position)
          beacons_encountered += 1
          position += 1
          moved = true
          break
        elsif range.include?(position)
          impossible_positions += (range.max - position + 1)
          position = range.max + 1
          moved = true
          break
        end
      end
      if !moved
        position += 1
      end
    end
    impossible_positions - (beacons_in_row.length - beacons_encountered)
  end

  def part_2
    max_coordinate = 4000000

    (0..max_coordinate).each do |row|
      sensor_ranges = sensors.map do |sensor| 
        sensor.beacon_range_ruled_out_in_row(row)
      end.filter { |range| range }
      
      position = 0
      while position <= max_coordinate
        moved = false
        sensor_ranges.each do |range|
          if beacon_positions.include?(Vec.new(position, row))
            position += 1
            moved = true
            break
          elsif range.include?(position)
            position = range.max + 1
            moved = true
            break
          end
        end
        if !moved && !beacon_positions.include?(Vec.new(position, row))
          return 4000000 * position + row
        elsif !moved
          position += 1
        end
      end
    end
  end

  private
  
  def parse(input_line)
    matches = input_line.scan(/\-*\d+/).map(&:to_i)
    sensor_position = Vec.new(matches[0], matches[1])
    beacon_position = Vec.new(matches[2], matches[3])

    [sensor_position, beacon_position]
  end

  class Sensor
    include AoCUtils

    attr_reader :position, :beacon_position, :beacon_distance
    def initialize(sensor_position, beacon_position)
      @position = sensor_position
      @beacon_position = beacon_position
      @beacon_distance = sensor_position.manhattan_dist(beacon_position)
    end

    def manhattan_dist(vec)
      position.manhattan_dist(vec)
    end

    def beacon_range_ruled_out_in_row(row)
      distance_to_row = (position.y - row).abs
      distance_in_row = (beacon_distance - distance_to_row)
      return nil unless distance_in_row >= 0
      
      left = position.x - distance_in_row
      right = position.x + distance_in_row
      (left..right)
    end
  end
end

### MAIN
solver = Day15.new
puts solver.part_1
puts solver.part_2
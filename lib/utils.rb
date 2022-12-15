module AoCUtils
  def read_input
    file = "input/input_#{@day}.txt"
    File.read(file)
  end

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
    
    def manhattan_norm
      x.abs + y.abs
    end

    def manhattan_dist(other)
      (self - other).manhattan_norm
    end

  end
end


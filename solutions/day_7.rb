require_relative '../lib/utils'
require 'pry'

class Day7
  include AoCUtils

  attr_reader :day, :input
  def initialize
    @day = 7
    @input = read_input.split("\n")
  end

  def part_1
    dirs_with_sizes = calculate_sizes(dirs)
    dirs_with_sizes.filter { |k, v| (v <= 100000) }.
      sum  { |k, v| v }
  end

  def part_2
    dirs_with_sizes = calculate_sizes(dirs)

    unused = 70000000 - dirs_with_sizes['/']
    to_free_up = 30000000 - unused
    
    dirs_with_sizes.filter { |k, v| (v >= to_free_up) }.
      sort_by { |k, v| v }.
      first[1]
  end
  
  

  def parse_input
    commands_responses = []
    input.each do |line|
      if line[0] == '$'
        commands_responses << CommandResponse.new(line[2..])
      else
        commands_responses.last.response << line 
      end
    end

    commands_responses
  end

  def dirs
    cwd = Directory.new('/', nil)
    dirs = {'/' => cwd}

    parse_input.each do |cr|  

      if cr.command[..1] == 'cd'
        if cr.command[3..] == '/'
          next
        elsif cr.command[3..] == '..'
          cwd = cwd.parent
        else
          subdir_name = cwd.name + cr.command[3..] + '/'
          if !cwd.subdirs[subdir_name]
            subdir = Directory.new(subdir_name, cwd)
            cwd.subdirs[subdir_name] = subdir
            dirs[subdir_name] = subdir
          end
          cwd = cwd.subdirs[subdir_name]
        end

      elsif cr.command[..1] == 'ls'
        cr.response.each do |response|
          if response[..2] == 'dir'
            subdir_name = cwd.name + response[4..] + '/'
            if !cwd.subdirs[subdir_name]
              subdir = Directory.new(subdir_name, cwd)
              cwd.subdirs[subdir_name] = subdir
              dirs[subdir_name] = subdir
            end
          else
            m = /(?<size>\d+) (?<name>.+)/.match(response)
            cwd.files[m[:name]] = File.new(m[:name], cwd, m[:size].to_i)
          end
        end
      else 
        raise ArgumentError.new
      end
    end

    dirs
  end

  def calculate_sizes(dirs)
    dirs.map do |name, dir|
      [name, dir.size]
    end.
      to_h
  end

  class CommandResponse
    attr_reader :command
    attr_accessor :response

    def initialize(command)
      @command = command
      @response = []
    end
  end

  class File
    attr_reader :name, :parent, :size
    
    def initialize(name, parent, size)
      @name = name
      @parent = parent
      @size = size
    end
  end

  class Directory

    attr_reader :name, :parent
    attr_accessor :files, :subdirs
    
    def initialize(name, parent)
      @name = name
      @parent = parent
      @files = {}
      @subdirs = {}
    end

    def size
      file_sum = @files.map do |name, file|
        file.size
      end.sum

      dir_sum = @subdirs.map do |name, dir|
        dir.size
      end.sum
      
      file_sum + dir_sum
    end
  end
  
end

### MAIN

solver = Day7.new
puts solver.part_1
puts solver.part_2
### helpers

def elf_sums(data)
  data.split(/\n\n/).map do |elf_data|
    elf_data.split.map(&:to_i).sum
  end
end

### problems

def part_1
  input_file = 'input.txt'
  data = File.read(input_file)

  elf_sums(data).max
end

def part_2
  input_file = 'input.txt'
  data = File.read(input_file)

  elf_sums(data).sort.reverse[...3].sum
end

### MAIN

puts part_1
puts part_2
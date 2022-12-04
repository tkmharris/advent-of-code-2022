### helpers

def score_1(other_move, self_move)
  move_scores = {
    X: 1, Y: 2, Z: 3
  }
  
  battle_scores = {
    A: {X: 3, Y: 6, Z: 0},
    B: {X: 0, Y: 3, Z: 6},
    C: {X: 6, Y: 0, Z: 3}
  }

  move_scores[self_move] + battle_scores[other_move][self_move]
end

def score_2(other_move, self_move)
  move_scores = {
    A: {X: 3, Y: 1, Z: 2},
    B: {X: 1, Y: 2, Z: 3},
    C: {X: 2, Y: 3, Z: 1}
  }
  
  battle_scores = {
    X: 0, Y: 3, Z: 6
  }

  move_scores[other_move][self_move] + battle_scores[self_move]
end

### problems

def part_1
  input_file = 'input.txt'
  data = File.read(input_file)
  
  turns = data.split(/\n/).map(&:split).map { |turn| turn.map(&:to_sym) } 
  turns.map { |turn| score_1(*turn)}.sum
end

def part_2
  input_file = 'input.txt'
  data = File.read(input_file)

  turns = data.split(/\n/).map(&:split).map { |turn| turn.map(&:to_sym) } 
  turns.map { |turn| score_2(*turn)}.sum
end

### MAIN

puts part_1
puts part_2


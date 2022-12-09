require_relative '../answers/answers'

day = ARGV[0]

solution_file = "solutions/day_#{day}.rb"
spec_file = "spec/day_#{day}_spec.rb"

# Outline solution file. Don't overwrite it if it already exists.
if !File.exists?(solution_file)
  solution_file_contents = File.read('script/templates/solution_template').gsub("<<day>>", day)
  File.write(solution_file, solution_file_contents)
end

# Create spec file.
spec_file_contents = File.read('script/templates/spec_template').gsub("<<day>>", day)
File.write(spec_file, spec_file_contents)
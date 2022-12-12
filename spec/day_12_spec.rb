require_relative '../answers/answers'
require_relative "../solutions/day_12"

describe Day12 do
  describe '#part_1' do
    subject do
      Day12.new.part_1
    end

    it 'gives the correct answer on the problem input data' do
      expect(subject).to eq(ANSWERS[:day_12][:part_1])
    end
  end

  describe '#part_2' do
    subject do
      Day12.new.part_2
    end

    it 'gives the correct answer on the problem input data' do
      expect(subject).to eq(ANSWERS[:day_12][:part_2])
    end
  end
end
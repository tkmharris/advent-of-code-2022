require_relative '../answers/answers'
require_relative "../../solutions/day_2"

describe Day2 do
  describe '#part_1' do
    subject do
      Day2.new.part_1
    end

    it 'gives the correct answer on the problem input data' do
      expect(subject).to eq(ANSWERS[:day_2][:part_1])
    end
  end

  describe '#part_2' do
    subject do
      Day2.new.part_2
    end

    it 'gives the correct answer on the problem input data' do
      expect(subject).to eq(ANSWERS[:day_2][:part_2])
    end
  end
end
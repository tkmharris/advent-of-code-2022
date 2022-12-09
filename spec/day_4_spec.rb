require_relative '../answers/answers'
require_relative "../../solutions/day_4"

describe Day4 do
  describe '#part_1' do
    subject do
      Day4.new.part_1
    end

    it 'gives the correct answer on the problem input data' do
      expect(subject).to eq(ANSWERS[:day_4][:part_1])
    end
  end

  describe '#part_2' do
    subject do
      Day4.new.part_2
    end

    it 'gives the correct answer on the problem input data' do
      expect(subject).to eq(ANSWERS[:day_4][:part_2])
    end
  end
end
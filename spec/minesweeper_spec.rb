require_relative '../minesweeper'

describe Minesweeper do
  let (:width) {10}
  let(:height) {  5}
  let(:num_mines) {15}
  context "#new" do
    context "when all parameters are specified" do
      it "width == 10, height == 5, num_mines == 15" do
        minesweeper = Minesweeper.new(10, 5, 15)
        expect(minesweeper.width).to eq(width)
        expect(minesweeper.height).to eq(height)
        expect(minesweeper.num_mines).to eq(num_mines)
      end
    end
  end
end

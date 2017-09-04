require_relative '../minesweeper'

describe Board do
  context "#new" do
    let(:width) {10}
    let(:height) {5}
    let(:arr) {[0]*3}
    context "verify initialization" do
      it "width == 10, height == 5 and board[key] == 0" do
        board = Board.new(width, height)
        bHash = board.hashBoard
        expect(board.width).to eq(width)
        expect(board.height).to eq(height)
        expect([bHash[0],bHash[1000000],bHash[42]]).to include(*arr)
      end
    end
  end
  context "#pairToKey" do
    context "test cases" do
      board = Board.new(100000, 500)
      it "x == 0, y == 0, return 0" do
        expect(board.pairToKey(0,0)).to eq(0)
      end
      it "x == 10, y == 5, return 0" do
      expect(board.pairToKey(10,5)).to eq(500000005)
      end
      it "x == 3, y == 2, return 0" do
      expect(board.pairToKey(3,2)).to eq(150000002)
      end
    end
  end
end

describe Minesweeper do
  let(:width) {10}
  let(:height) {5}
  let(:num_mines) {15}
  context "#new" do
    context "when all parameters are specified" do
      it "width == 10, height == 5, num_mines == 15" do
        minesweeper = Minesweeper.new(width, height, num_mines)
        expect(minesweeper.board.width).to eq(width)
        expect(minesweeper.board.height).to eq(height)
        expect(minesweeper.num_mines).to eq(num_mines)
      end
    end
    context "no params" do
      it "default board 8x8 10 mines" do
        minesweeper = Minesweeper.new()
        expect(minesweeper.board.width).to eq(8)
        expect(minesweeper.board.height).to eq(8)
        expect(minesweeper.num_mines).to eq(10)
      end
    end
    context "Test invalid params" do
      context "Pass params less than zero" do
        it "width == -1 raise ArgumentError" do
          expect{Minesweeper.new(-1,0,3)}.to raise_error(ArgumentError)
        end
        it "num_mines == -33 raise ArgumentError" do
          expect{Minesweeper.new(1,0,-33)}.to raise_error(ArgumentError)
        end
        it "all params less than zero raise ArgumentError" do
          expect{Minesweeper.new(-1,-11,-3)}.to raise_error(ArgumentError)
        end
      end
      context "Pass params not numbers" do
        it "width == 'q' raise ArgumentError" do
          expect{Minesweeper.new('q',0,3)}.to raise_error(ArgumentError)
        end
        it "num_mines == 'vinte' raise ArgumentError" do
          expect{Minesweeper.new(1,0,'vinte')}.to raise_error(ArgumentError)
        end
        it "all params not numbers raise ArgumentError" do
          expect{Minesweeper.new("1",'11','3')}.to raise_error(ArgumentError)
        end
      end
    end
  end
end

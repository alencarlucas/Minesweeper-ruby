require_relative '../minesweeper'

describe Board do
  context "#new" do
    let(:width) {10}
    let(:height) {5}
    let(:arr) {['.']*3}
    context "verify initialization" do
      it "width == 10, height == 5 and board[key] == 0" do
        board = Board.new(width, height)
        expect(board.width).to eq(width)
        expect(board.height).to eq(height)
        expect(board.valid_plays).to eq(0)
        expect([board[0,0],board[1000000,500],board[4,2]]).to include(*arr)
      end
    end
  end
  context "#pairToKey" do
    context "test cases" do
      board = Board.new(100000, 500)
      it "x == 0, y == 0, return 0" do
        expect(board.pairToKey(0,0)).to eq(0)
      end
      it "x == 10, y == 5, return 500000005" do
      expect(board.pairToKey(10,5)).to eq(5005)
      end
      it "x == 3, y == 2, return 150000002" do
      expect(board.pairToKey(3,2)).to eq(1502)
      end
    end
  end
  context "#verify_mine" do
    context "test cases" do
      it "all cells are mines" do
        board = Board.new(5,5)
        board.setRandomMines(25)
        expect(board.verify_mine(1,'')).to eq(false)
        expect(board.verify_mine(12,'')).to eq(false)
        expect(board.verify_mine(7,'')).to eq(false)
      end
      it "board without mines" do
        board = Board.new(5,5)
        expect(board.verify_mine(1,'')).to eq(true)
        expect(board.verify_mine(12,'')).to eq(true)
        expect(board.verify_mine(7,'')).to eq(true)
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
        expect(minesweeper.size).to eq(50)
      end
    end
    context "no params" do
      it "default board 8x8 10 mines" do
        minesweeper = Minesweeper.new()
        expect(minesweeper.board.width).to eq(8)
        expect(minesweeper.board.height).to eq(8)
        expect(minesweeper.num_mines).to eq(10)
        expect(minesweeper.size).to eq(64)
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
  context "Test the app !" do
    context "you win" do
      it "ss" do
        game = Minesweeper.new()
  end
end

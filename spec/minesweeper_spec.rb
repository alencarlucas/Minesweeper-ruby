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
  context "#verify_Bomb" do
    context "test cases" do
      it "all cells are Bombs" do
        board = Board.new(5,5)
        board.setRandomMines(25)
        expect(board.verify_Bomb(1,' ')).to eq(false)
        expect(board.verify_Bomb(12,' ')).to eq(false)
        expect(board.verify_Bomb(7,' ')).to eq(false)
      end
      it "board without Bombs" do
        board = Board.new(5,5)
        expect(board.verify_Bomb(1,' ')).to eq(true)
        expect(board.verify_Bomb(12,' ')).to eq(true)
        expect(board.verify_Bomb(7,' ')).to eq(true)
      end
    end
  end
end

describe Minesweeper do
  let(:width) {10}
  let(:height) {5}
  let(:num_Bombs) {15}
  context "#new" do
    context "when all parameters are specified" do
      it "width == 10, height == 5, num_Bombs == 15" do
        Bombsweeper = Minesweeper.new(width, height, num_Bombs)
        expect(Bombsweeper.board.width).to eq(width)
        expect(Bombsweeper.board.height).to eq(height)
        expect(Bombsweeper.num_Bombs).to eq(num_Bombs)
        expect(Bombsweeper.size).to eq(50)
      end
    end
    context "no params" do
      it "default board 8x8 10 Bombs" do
        Bombsweeper = Minesweeper.new()
        expect(Bombsweeper.board.width).to eq(8)
        expect(Bombsweeper.board.height).to eq(8)
        expect(Bombsweeper.num_Bombs).to eq(10)
        expect(Bombsweeper.size).to eq(64)
      end
    end
    context "Test invalid params" do
      context "Pass params less than zero" do
        it "width == -1 raise ArgumentError" do
          expect{Minesweeper.new(-1,0,3)}.to raise_error(ArgumentError)
        end
        it "num_Bombs == -33 raise ArgumentError" do
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
        it "num_Bombs == 'vinte' raise ArgumentError" do
          expect{Minesweeper.new(1,0,'vinte')}.to raise_error(ArgumentError)
        end
        it "all params not numbers raise ArgumentError" do
          expect{Minesweeper.new("1",'11','3')}.to raise_error(ArgumentError)
        end
      end
    end
  end
  context "Run game" do
    context "Simulate using random" do
      let(:width) {10}
      let(:height) {20}
      let(:num_Bombs) {50}
      it "Quero Exemple" do

        game = Minesweeper.new(width, height, num_Bombs)

        while game.still_playing?
          valid_move = game.play(rand(width), rand(height))
          valid_flag = game.flag(rand(width), rand(height))
          if valid_move or valid_flag
          printer = (rand > 0.5) ? SimplePrinter.new : PrettyPrinter.new
          printer.print(game.board_state)
          end
        end

        puts "Fim do jogo!"
        if game.victory?
          puts "Você venceu!"
        else
          puts "Você perdeu! As minas eram:"
          PrettyPrinter.new.print(game.board_state(xray: true))
        end
      end
    end
  end
end

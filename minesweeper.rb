class Board
    attr_accessor :width, :height

    def initialize(x,y)
        @width = x
        @height = y
        @hashBoard = Hash.new(0)
    end

    def coordinateToIndex(xi,yi)
        xi*(@width*@height)+yi
    end

    def setRandomMines(maxMines)
        [*0..@width].sample(maxMines).zip([*0..@height].sample(maxMines)).each do |x,y|
            @hashBoard[coordinateToIndex(x.to_i,y.to_i)] = 1
        end
    end

end

class Minesweeper < Board
  attr_accessor :num_mines, :board

  def initialize width = 8, height = 8, num_mines = 10
      @num_mines = num_mines
      @board = Board.new(width,height)
      @board.setRandomMines(num_mines)
  end

end

class ArgumentError < StandardError

end

#class to represent the minesweeper board
class Board
    attr_accessor :width, :height, :hashBoard

    #initialize the board with size parameters
    #set all positions equals 0 (empty cell)
    def initialize(x,y)
        @width, @height = x, y
        @hashBoard = Hash.new(0)
    end

    def [](i)
        @hashBoard[i.to_sym]
    end

    #function used to refer a pair as a key
    def pairToKey(xi,yi)
        (xi*(@width*@height)+yi)
    end

    #set random cells equals 1 (bomb position)
    def setRandomMines(maxMines)
        [*0..@width].sample(maxMines).zip([*0..@height].sample(maxMines)).each do |x,y|
            @hashBoard[pairToKey(x.to_i,y.to_i)] = 1
        end
    end

end

class Minesweeper < Board
  attr_accessor :num_mines, :board

  def initialize width = 8, height = 8, num_mines = 10
    raise ArgumentError.new "all params need be numbers" if [width,height,num_mines].all? {|i| not(i.is_a? Numeric) }
    raise ArgumentError.new "all params need be greater than zero" if ([width,height,num_mines].min.to_i < 0)
    @num_mines = num_mines
    @board = Board.new(width,height)
    @board.setRandomMines(num_mines)
  end
end

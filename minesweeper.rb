

#class to represent the minesweeper board
class Board
    attr_accessor :width, :height, :hashBoard, :size

    #initialize the board with size parameters
    #set all positions equals 0 (empty cell)
    def initialize(x,y)
        @width, @height, @size = x, y, x.to_i*y.to_i
        @hashBoard = Hash.new('.')
        @hashBomb = Hash.new()
    end

    def [](x,y)
      @hashBoard[pairToKey(x,y)]
    end

    def verify_bomb index, value
      @hashBomb[index] != '#' || value != ''
    end

    def []=(x,y,value)
      index = pairToKey(x,y)
      if(verify_bomb(index, value))
        @hashBoard[pairToKey(x,y)] = value
      else
        false
      end
    end

    #function used to refer a pair as a key
    def pairToKey(xi,yi)
      (xi*(@height)+yi)
    end

    #set random cells equals 1 (bomb position)
    def setRandomMines(maxMines)
      [*0..@width].sample(maxMines).product([*0..@height].sample(maxMines)).each do |x,y|
          @hashBomb[pairToKey(x.to_i,y.to_i)] = '#'
      end
    end

end

class Minesweeper < Board
  attr_accessor :num_mines, :size, :board, :valid_plays

  def initialize width = 8, height = 8, num_mines = 10
    raise ArgumentError.new "all params need be numbers" if [width,height,num_mines].all? {|i| not(i.is_a? Numeric) }
    raise ArgumentError.new "all params need be greater than zero" if ([width,height,num_mines].min.to_i < 0)
    @num_mines, @valid_plays, @board = num_mines, 0, Board.new(width,height)
    @board.setRandomMines(num_mines)
  end

  def flag x,y
    case @board[x,y]
      when '.'
        @board[x,y] = 'F'
      when 'F'
        @board[x,y] = '.'
      else
        false
    end
  end
end



#class to represent the minesweeper board
class Board
    attr_accessor :width, :height, :hashBoard

    #initialize the board with size parameters
    #set all positions equals 0 (empty cell)
    def initialize(x,y)
        @width, @height = x, y
        @hashBoard = Hash.new('.')
        @hashmine = Hash.new()
        @clicked_a_mine = false
    end

    def [](i)
      @hashBoard[i]
    end

    def [](x,y)
      @hashBoard[pairToKey(x,y)]
    end

    def verify_mine index, value
      clicked_a_mine = @hashmine[index] != '#' || value != ''
    end

    def []=(x,y,value)
      index = pairToKey(x,y)
      if(verify_mine(index, value))
        @hashBoard[pairToKey(x,y)] = value
      else
        false
      end
    end

    #function used to refer a pair as a key
    def pairToKey(xi,yi)
      (xi*(@height)+yi)
    end

    #set random cells equals 1 (mine position)
    def setRandomMines(maxMines)
      [*0..@width-1].product([*0..@height-1]).sample(maxMines).each do |pair|
          @hashmine[pairToKey(pair[0].to_i,pair[1].to_i)] = '#'
      end
    end

    def getCellStatus index
        @hashmine[index] == '#' ? '#' : @hashBoard[index]
    end

end

class Minesweeper < Board
  attr_accessor :num_mines, :size, :board, :valid_plays

  def initialize width = 8, height = 8, num_mines = 10
    raise ArgumentError.new "all params need be numbers" if [width,height,num_mines].all? {|i| not(i.is_a? Numeric) }
    raise ArgumentError.new "all params need be greater than zero" if ([width,height,num_mines].min.to_i < 0)
    @num_mines, @valid_plays, @size = num_mines, 0, width.to_i*height.to_i
    @board = Board.new(width,height)
    @board.setRandomMines(num_mines)
  end

  def victory?
    valid_plays == @size - @num_mines
  end

  def still_playing?
    clicked_a_mine || victory?
  end

  def SimplePrinter
    [*1..@size].each do |e|
      if( e.to_i % @board.height.to_i == 0 )
        puts @board.getCellStatus(e)
      else
        print @board.getCellStatus(e)
      end
    end
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

Minesweeper.new().SimplePrinter

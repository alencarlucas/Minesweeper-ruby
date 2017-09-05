#class to represent the minesweeper board
class Board
  attr_accessor :width, :height, :clicked_a_mine, :hashBoard

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
    @hashmine[index] != '#' || value != ' '
  end

  def unmark
    [*1..@width*@height].each { |e| @hashBoard[e] = (@hashBoard[e] == 'xF' ? "F" : @hashBoard[e]) }
  end

  def verify_neighbor x, y
    flagShow = true
    arr = Array.new()
    [-1,1,0].product([1,-1,0]).each do |pair|
      if(pair[0] != 0 || pair[1] != 0 )
        neighbor = [pair[0]+x, pair[1]+y]
        index = pairToKey(neighbor[0],neighbor[1])
        if([*1..@width*@height].include?(index) && @hashmine[index] != '#')
          #push [[x,y],index]
          arr.push([neighbor,index])
        else
          flagShow = false
        end
      end
    end
    if(flagShow)
      arr.each do |neighbor|
        if(@hashBoard[neighbor[1]] == '.' || @hashBoard[neighbor[1]] == 'F')
          @hashBoard[neighbor[1]] = (@hashBoard[neighbor[1]] == 'F' ? "xF" : ' ')
          verify_neighbor neighbor[0][0], neighbor[0][1]
        end
      end
    end
  end

  def []=(x,y,value)
    index = pairToKey(x,y)
    if(verify_mine(index, value))
      @hashBoard[index] = value
      if(value == ' ')
        verify_neighbor x, y
        unmark
      end
    else
      @hashBoard[index] = 'X'
      @clicked_a_mine = true
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
        if(pair[0] != 0 && pair[1] != 0)
          @hashmine[pairToKey(pair[0].to_i,pair[1].to_i)] = '#'
          puts pairToKey(pair[0].to_i,pair[1].to_i)
        end
    end
  end

  def getCellStatus index
      @hashmine[index] == '#' ? '#' : @hashBoard[index]
  end

end

class Minesweeper
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
    !@board.clicked_a_mine || victory?
  end

  def play x,y
    if @board[x,y] == '.'
      @board[x,y] = ' '
    else
      false
    end
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

game = Minesweeper.new()

game.SimplePrinter
game.flag 1,3
if game.play 1,2
  puts ''
  game.SimplePrinter
end
# if game.play 5,6
#   puts ''
#   game.SimplePrinter
# end
# if game.play 4,8
#   puts ''
#   game.SimplePrinter
# end
# if game.play 3,3
#   puts ''
#   game.SimplePrinter
# end
# if game.play 1,4
#   puts ''
#   game.SimplePrinter
# end

if(!game.still_playing?)
  if game.victory?
    puts 'venceu'
  else
    puts 'perdeu'
  end
else
  puts 'continua'
end

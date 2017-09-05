module InterfacePrinter
  def print stateHash
    raise "Not implemented"
  end
end

class SimplePrinter
  include InterfacePrinter

  def print state
    puts state[:to_print]
  end
end

class PrettyPrinter
  include InterfacePrinter

  def print state
    state[:to_print].each do |key, value|
      if key.to_i % state[:columns].to_i == 0
        puts value
      else
        $stdout.print (value.to_s + " ")
      end
    end
    puts '============================='
  end
end
#class to represent the minesweeper board
class Board
  attr_accessor :width, :height, :clicked_a_mine, :hashBoard, :valid_plays

  #initialize the board with size parameters
  #set all positions equals 0 (empty cell)
  def initialize(x,y)
    @width, @height = x, y
    @hashBoard = Hash.new('.')
    @hashmine = Hash.new()
    @clicked_a_mine = false
    @valid_plays = 0
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
    [*1..@width*@height].each do |e|
      if (@hashBoard[e] == 'xF' )
        @hashBoard[e] = 'F'
        @valid_plays = @valid_plays - 1
      end
    end
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
          @valid_plays = @valid_plays + 1
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
        @valid_plays = @valid_plays + 1
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
        if(pair[0] != 0 || pair[1] != 0)
          @hashmine[pairToKey(pair[0].to_i,pair[1].to_i)] = '#'
        end
    end
  end

  def getCellStatus index, flag_xray
      @hashmine[index] == '#' && flag_xray ? '#' : @hashBoard[index]
  end

end

class Minesweeper
  attr_accessor :num_mines, :size, :board

  def initialize width = 8, height = 8, num_mines = 10
    raise ArgumentError.new "all params need be numbers" if [width,height,num_mines].all? {|i| not(i.is_a? Numeric) }
    raise ArgumentError.new "all params need be greater than zero" if ([width,height,num_mines].min.to_i < 0)
    @num_mines, @size = num_mines, width.to_i*height.to_i
    @board = Board.new(width,height)
    @board.setRandomMines(num_mines)
  end

  def victory?
    board_state[:clicked_bomb].empty? && @board.valid_plays == @size - @num_mines
  end

  def still_playing?
    board_state[:clicked_bomb].empty? && !victory?
  end

  def play x,y
    if @board[x,y] == '.'
      @board[x,y] = ' '
    else
      false
    end
  end

  def board_state args = {}
    xray = args.has_key?(:xray) ? args[:xray] : false
    unknown_cell = Array.new()
    clear_cell = Array.new()
    flag = Array.new()
    bomb = Array.new()
    clicked_bomb = Array.new()
    to_print = Hash.new()
    [*1..@size].each do |e|
      case board.getCellStatus(e, xray)
      when '.'
        unknown_cell.push(e)
      when ' '
        clear_cell.push(e)
      when '#'
        bomb.push(e)
      when 'F'
        flag.push(e)
      when 'X'
        clicked_bomb.push(e)
      end
      to_print[e] = board.getCellStatus(e, xray)
    end
    Hash[
      :"unknown_cell" => unknown_cell,
      :"clear_cell" => clear_cell,
      :"bomb" => bomb,
      :"flag" => flag,
      :"clicked_bomb" => clicked_bomb,
      :"xray" => xray,
      :"to_print" => to_print,
      :"columns" => @board.height
    ]
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

width, height, num_mines = 10, 4, 1
game = Minesweeper.new(width, height, num_mines)

while game.still_playing?
  valid_move = game.play(rand(width), rand(height))
  valid_flag = game.flag(rand(width), rand(height))
  if valid_move or valid_flag
    printer = (rand > 0.5) ? PrettyPrinter.new : PrettyPrinter.new
    printer.print(game.board_state)
    puts game.board_state[:clicked_bomb].empty?
    puts game.victory?
  end
end

puts "Fim do jogo!"
if game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  PrettyPrinter.new.print(game.board_state(xray: true))
end

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

#Classe que representa o tabuleiro do jogo
class Board
  attr_accessor :width, :height, :hashBoard, :valid_plays

  #inicializa o tabuleiro com os parâmetros de tamanho
  #seta todas as posições como '.' (célula vazia)
  def initialize(x,y)
    @width, @height = x, y
    @hashBoard = Hash.new('.')
    @hashBomb = Hash.new()
    @valid_plays = 0
  end

  def [](i)
    @hashBoard[i]
  end

  def [](x,y)
    @hashBoard[pairToKey(x,y)]
  end

  #verifica se a posição que se esta querendo clicar é uma mina
  def verify_Bomb index, value
    @hashBomb[index] != '#' || value != ' '
  end

  #função usada para desmarcar de 'xF' para 'F' as posições visitadas
  #durante execução do método open_neighbors
  def unmark
    [*1..@width*@height].each do |e|
      if (@hashBoard[e] == 'xF' )
        @hashBoard[e] = 'F'
        @valid_plays = @valid_plays - 1
      end
    end
  end

  #função utilizada para "clicar" as posições vizinhas válidas
  #caso a posição esteja flagada ela é marcada como visitada 'xF'
  def open_neighbors arr
    arr.each do |neighbor|
      if(@hashBoard[neighbor[1]] == '.' || @hashBoard[neighbor[1]] == 'F')
        @hashBoard[neighbor[1]] = (@hashBoard[neighbor[1]] == 'F' ? "xF" : ' ')
        @valid_plays = @valid_plays + 1
        verify_neighbor neighbor[0][0], neighbor[0][1]
      end
    end
  end

  #verifica quais são os vizinhos de (x,y) que satisfazem
  #as condições para serem abertos
  def verify_neighbor x, y
    arr = Array.new()
    [-1,1,0].product([1,-1,0]).each do |pair|
      if(pair[0] != 0 || pair[1] != 0 )
        neighbor = [pair[0].to_i+x, pair[1].to_i+y]
        index = pairToKey(neighbor[0],neighbor[1])
        if([*1..@width*@height].include?(index))
          if(@hashBomb[index] != '#')
            #push [[x,y],index]
            arr.push([neighbor,index])
          else
            return
          end
        end
      end
    end
    open_neighbors(arr)
  end

  def []=(x,y,value)
    index = pairToKey(x,y)
    #verifica se não vai clicar na bomba
    if(verify_Bomb(index, value))
      @hashBoard[index] = value
      #se abriu uma célula vazia chama a função de verificar vizinhos e
      #incrementa o contador de jogadas válidas
      if(value == ' ')
        verify_neighbor x, y
        @valid_plays = @valid_plays + 1
        unmark
      end
    #se clicou na bomba atribui "X" à posição e retorna false
    else
      @hashBoard[index] = 'X'
      false
    end
  end

  #Função usada para converter uma coordenada (x,y) para um inteiro único
  def pairToKey(xi,yi)
    (xi*(@height)+yi)
  end

  #Define e armazena as posições com bombas
  def setRandomMines(maxMines)
    [*0..@width-1].product([*0..@height-1]).sample(maxMines).each do |pair|
        if(pair[0] != 0 || pair[1] != 0)
          @hashBomb[pairToKey(pair[0].to_i,pair[1].to_i)] = '#'
        end
    end
  end

  #retorna o status da célula, se a flag_xray == true e a posição for uma bomba
  #apresenta-a na tela
  def getCellStatus index, flag_xray, flag_finish
      @hashBomb[index] == '#' && (flag_xray&&!flag_finish) ? '#' : @hashBoard[index]
  end

end

class Minesweeper
  attr_accessor :num_Bombs, :size, :board, :flag_finish

  def initialize width = 8, height = 8, num_Bombs = 10
    raise ArgumentError.new "all params need be numbers" if [width,height,num_Bombs].all? {|i| not(i.is_a? Numeric) }
    raise ArgumentError.new "all params need be greater than zero" if ([width,height,num_Bombs].min.to_i < 0)
    @num_Bombs, @size = num_Bombs, width.to_i*height.to_i
    @board = Board.new(width,height)
    @board.setRandomMines(num_Bombs)
    @flag_finish = true
  end

  #retorna verdadeiro caso não tenha clicado em uma bomba e tenha sobrado
  #no tabuleiro n células, onde n é igual ao número de bombas
  def victory?
    board_state[:clicked_bomb].empty? && @board.valid_plays == @size - @num_Bombs
  end

  def still_playing?
    @flag_finish = (board_state[:clicked_bomb].empty? && !victory?)
    @flag_finish
  end

  #Tenta realizar uma jogada, caso a posição seja inválida retorna false
  def play x,y
    if @board[x,y] == '.'
      @board[x,y] = ' '
    else
      false
    end
    true
  end

  #retorna um hash com o estado do jogo
  # Hash[
  #   :"unknown_cell" => célula que não foram clicadas,
  #   :"clear_cell" => células clicadas e que estavam vazias,
  #   :"bomb" => posições das bombas (precisa do parametro xray),
  #   :"flag" => posições das flags,
  #   :"clicked_bomb" => posição da bomba clicada,
  #   :"xray" => mostrar ou não a posição das bombas,
  #   :"to_print" => hash com os valores para imprimir ,
  #   :"columns" => número de colunas
  # ]
  def board_state args = {}
    xray = args.has_key?(:xray) ? args[:xray] : false
    unknown_cell, clear_cell, flag, bomb, clicked_bomb = Array.new(5) { [] }
    to_print = Hash.new()
    [*1..@size].each do |e|
      case board.getCellStatus(e, xray, @flag_finish)
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
      to_print[e] = board.getCellStatus(e, xray, @flag_finish)
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

  #Função utilizada para 'flagar' uma célula oculta
  #se a célula já estiver flagada volta-a ao estado anterior (célula oculta)
  def flag x,y
    case @board[x,y]
      when '.'
        @board[x,y] = 'F'
      when 'F'
        @board[x,y] = '.'
      else
        false
    end
    true
  end
end

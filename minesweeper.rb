class Minesweeper
  attr_accessor :width, :height, :num_mines
  def initialize width, height = width, num_mines = width
      @width = width
      @height = height
      @num_mines = num_mines
  end
end

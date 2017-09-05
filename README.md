# Minesweeper-ruby
Minesweeper in ruby


rspec spec --format documentation

	Board

    #new
      verify initialization
        width == 10, height == 5 and board[key] == 0

    #pairToKey
      test cases
        x == 0, y == 0, return 501
        x == 10, y == 5, return 4505
        x == 3, y == 2, return 1002

    #verify_Bomb
      test cases
        all cells are Bombs
        board without Bombs

	Minesweeper

    #new
      when all parameters are specified
        width == 10, height == 5, num_Bombs == 15
      no params
        default board 8x8 10 Bombs
      Test invalid params
        Pass params less than zero
          width == -1 raise ArgumentError
          num_Bombs == -33 raise ArgumentError
          all params less than zero raise ArgumentError
        Pass params not numbers
          width == 'q' raise ArgumentError
          num_Bombs == 'vinte' raise ArgumentError
          all params not numbers raise ArgumentError

    Run game
      Simulate using random
        width == 10, height == 20, num_Bombs == 150
          Fim do jogo!
          Você perdeu! As minas eram:
          # # # # . . # . . # # # # # # # # # . #
          # # # # # # . # # # # . # # # . # # . #
          # # # . # # # . # . # . # # # # . # # .
          # # . # # # # # # # # # # # # . # # # .
          # # . # # . # # # . . # # # . . # # # .
          . . # . # # # # # . # # # . # # # # . .
          # # . # # . . # # # # . # # # # # # . #
          . # # # # . . . # # . # # # # # # # # #
          # # # # # # # # # # # . # # . # # # # .
          # . # # # # # # . # . # # # # . # # # .
          =============================
          Should lose
        width == 10, height == 20, num_Bombs == 1
          Fim do jogo!
          Você venceu!
          Should win

Finished in 0.01562 seconds (files took 0.25726 seconds to load)
16 examples, 0 failures

# one player is x and one player is o
# the board is displayed between each person's turn
# the board has to change based on players' inputs
#
# players can be a class - there will be 2 of them
# players need method that will access the 2D array
# players exist inside the board class
# the board can have x value 1...3, and y value a...c
#   1 2 3
# a _ _ _
# b _ _ _
# c _ _ _
# the above is a 2D array

class Tictactoe
  attr_accessor :board :player1 :player2

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @board = [
      %w(a _ _ _)\n
      %w(b _ _ _)\n
      %w(c _ _ _)\n
    ]
    @go_first = rand(10) <= 5 ? @player1 : @player2
  end

  class Player(player_name)

    def initialize(player_name)
      @player_name = player_name
    end

    def move(x_coord, y_coord)
      @board[x_coord][y_coord] = @player1 ? "x" : "o"
    end

  end
end

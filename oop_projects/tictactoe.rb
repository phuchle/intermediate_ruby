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
  # attr_accessor :board, :player1, :player2

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player1.name = player1

    @player2 = Player.new(player2)
    @player2.name = player2

    @board = [
      %w(0 1 2 3),
      %w(1 _ _ _),
      %w(2 _ _ _),
      %w(3 _ _ _),
    ]
  end

  def board
    puts @board[0].join(" ")
    puts @board[1].join(" ")
    puts @board[2].join(" ")
    puts @board[3].join(" ")
  end

  def move(current_player, x_coord, y_coord)
    @board[x_coord][y_coord] = current_player == @player1 ? "x" : "o"
    self.board
  end

  class Player
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
end


puts "==========================="
puts "  Welcome to Tic-Tac-Toe.\n"
puts "==========================="

puts "Please enter the first player's name:\n"
player1 = gets.chomp
puts "Thank you.  Player one is #{player1}.\n\n"

puts "Please enter player two's name:"
player2 = gets.chomp
puts "Thank you.  Player two is #{player2}.\n\n"



game = Tictactoe.new(player1, player2)

puts game.board
puts "Enter the board coordinates you wish to mark"
puts "e.g. 1,3 marks the bottom left corner of the board."

winner = false

until winner
  case win
    winner = true when game.board[1].all? {|x|}
    # return winner when any row or column are all x or o
    # winner depends on who places x or o
    #
  idx = 1
  current_player = idx % 2 == 0 ? @player2 : @player1

  puts "#{current_player}, enter the coordinates you wish to mark:"
  x_coord, y_coord = gets.chomp

  game.move(current_player, x_coord, y_coord)

  idx += 1

end

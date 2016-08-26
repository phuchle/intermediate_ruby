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
  attr_reader :go_first

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @board = [
      %w(0 1 2 3),
      %w(1 _ _ _),
      %w(2 _ _ _),
      %w(3 _ _ _),
    ]

  end

  def board
    puts @board[0].to_s
    puts @board[1].to_s
    puts @board[2].to_s
    puts @board[3].to_s
  end

  class Player
    def initialize(player_name)
      @player_name = player_name
    end

    def move(x_coord, y_coord)
      @board[x_coord][y_coord] = @player1 ? "x" : "o"
    end

  end
end

puts "Welcome to Tic-Tac-Toe."
puts "Please enter the first player's name:"
player1 = gets.chomp
puts "Thank you.  Player one is #{player1}."

puts "Please enter player two's name:"
player2 = gets.chomp
puts "Thank you.  Player two is #{player2}."

game = Tictactoe.new(player1, player2)

puts @board
puts "Enter the board coordinates you wish to mark"
puts "e.g. 1,3 marks the bottom left corner of the board."


puts "#{player1}, enter the coordinates you wish to mark:"
x_coord, y_coord = gets.chomp("x, y")
puts @board

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
# the game ends when a player has connected a row or column
# the game also ends when diagonal is filled
# the game can end when all tiles are filled with no winner
#

class Tictactoe
  # attr_accessor :board, :player1, :player2

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player1.name = player1

    @player2 = Player.new(player2)
    @player2.name = player2

    @demo_board = [
      %w(0 1 2 3),
      %w(1 _ _ _),
      %w(2 _ _ _),
      %w(3 _ _ _),
    ]

    @board = [
    #    0 1 2
      %w(_ _ _), # 0
      %w(_ _ _), # 1
      %w(_ _ _), # 2
    ]
  end

  def board
    puts @board[0].join(" ")
    puts @board[1].join(" ")
    puts @board[2].join(" ")
  end

  def win?
    rows = @board

    columns = []

    index = 0
    while index < rows.length - 1
      columns << rows.collect { |row| row[index] }
      index += 1
    end

    diagonal1 = [ @board[0][0], @board[1][1], @board[2][2] ]
    diagonal2 = [ @board[0][2], @board[1][1], @board[2][0] ]
    diagonals = [diagonal1, diagonal2]

    straight_lines = [rows, columns, diagonals] # how many dimensions is dis??

    true if straight_lines.any? { |line| line.filled? }
    false
  end

  def tie?
    self.board.flatten.none? { |char| char == "_" }
  end

  def filled?
    self.all? { |char| char == "x" || char == "o" }
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

puts game.demo_board + "\n"
puts "Enter the board coordinates you wish to mark.\n"
puts "e.g. 1,3 marks the bottom left corner of the board.\n"

game_ends = false

until game_ends
  idx = 1
  current_player = idx.odd? ? @player1 : @player2

  puts "#{current_player}, enter the coordinates you wish to mark:"
  x_coord, y_coord = gets.chomp

  game.move(current_player, x_coord - 1, y_coord - 1) # since array starts at 0

  if game.win?
    puts "#{current_player} wins!"
    game_ends = true
  elsif game.tie?
    puts "Nobody wins."
    game_ends = true
  end

  idx += 1
end

puts "Thank you for playing Tic-Tac-Toe!"

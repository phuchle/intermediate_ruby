# to-do
# raise errors for entering wrong coords, if a space is already marked
# which methods are protected and which are private?

class Array
  def filled?
    if self.all? { |char| char == "x"}
      true
    elsif self.all? { |char| char == "o"}
      true
    else
      false
    end
  end
end

class Tictactoe
  attr_accessor :board, :demo_board, :player1, :player2

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

  def demo_board
    puts @demo_board[0].join(" ")
    puts @demo_board[1].join(" ")
    puts @demo_board[2].join(" ")
    puts @demo_board[3].join(" ")
    puts "\n\n"
  end

  def win?
    rows = @board #2D array
    columns = [] #2D array
    0.upto(2) { |index| columns << rows.collect { |row| row[index] } }
    diagonal1 = [ @board[0][0], @board[1][1], @board[2][2] ] #1D arr
    diagonal2 = [ @board[0][2], @board[1][1], @board[2][0] ]
    diagonals = [diagonal1, diagonal2] #2D array

    straight_lines = [rows, columns, diagonals] # 3D array

    win_condition = false
    straight_lines.each do |straight_line|
      win_condition = true if straight_line.any? { |line| line.filled? }
    end
    win_condition
  end

  def tie?
    @board.flatten.none? { |char| char == "_" }
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

Gem.win_platform? ? (system "cls") : (system "clear")

puts "==========================="
puts "  Welcome to Tic-Tac-Toe.\n"
puts "==========================="

sleep 1

puts "Please enter the player one's name:\n"
player1 = gets.chomp
puts "Thank you."
sleep 1
puts "Player one is #{player1}.\n\n"
sleep 1

puts "Please enter player two's name:"
player2 = gets.chomp
puts "Thank you."
sleep 1
puts "Player two is #{player2}.\n\n"
sleep 1

puts "A new game will now begin!"
sleep 2

Gem.win_platform? ? (system "cls") : (system "clear")

game = Tictactoe.new(player1, player2)
sleep 2

puts "The board with coordinates is shown below:"
sleep 2
puts game.demo_board
sleep 2

puts "Enter the board coordinates you wish to mark.\n"
puts "e.g. 1,3 marks the bottom left corner of the board.\n\n\n"
sleep 3

sleep 1

game_ends = false

game.board

idx = 1
until game_ends
  current_player = idx.odd? ? game.player1 : game.player2
  puts "#{current_player.name}, enter the coordinates you wish to mark (1-3):"
  coords = gets.chomp.split(",").map!(&:to_i)
  x_coord, y_coord = coords[0] - 1, coords[1] - 1 # since array starts at 0

  game.move(current_player, x_coord, y_coord)

  if game.win?
    Gem.win_platform? ? (system "cls") : (system "clear")
    sleep 1
    10.times do
      puts "==========================="
      puts "#{current_player.name} wins!"
      puts "==========================="
      sleep 0.25
    end
    sleep 2
    game_ends = true
  elsif game.tie?
    puts "==========================="
    puts "       Nobody wins."
    puts "==========================="
    game_ends = true
  else
    game_ends = false
  end
  idx += 1
end

Gem.win_platform? ? (system "cls") : (system "clear")
puts "Thank you for playing Tic-Tac-Toe!"

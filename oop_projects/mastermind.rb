require 'byebug'

module Tooling
  class NotAColor < ArgumentError ; end
  class WrongInput < StandardError ; end
  class RepeatGuess < StandardError ; end

  COLORS = %w(red orange yellow green blue violet)

  def find_matches(guess, code)
   guess_copy = guess.dup
   code_copy = code.dup

   exact_match = 0
   color_match = 0

    code_copy.each_with_index do |code_color, code_index|
      if code_color == guess[code_index]
        exact_match += 1
        guess_copy[code_index] = nil
        code_copy[code_index] = nil
      end
    end

    code_copy.compact.each_with_index do |code_color, code_index|
      if guess_copy.compact.include?(code_color)
        color_match += 1
        guess_copy[guess_copy.index(code_color)] = nil
      end
    end
    [exact_match, color_match]
  end
end

class Mastermind
  include Tooling

  attr_accessor :guess_history, :code
  attr_reader :turns

  def initialize
    self.intro
    self.instructions
    @code = []
    self.make_code
    @turns = 1
    @guess_history = {}
  end

  def list_colors
    COLORS.each do |color|
      puts color.capitalize
      #sleep 1
    end
    puts "\n\n"
  end

  def intro
    Gem.win_platform? ? (system "cls") : (system "clear")

    puts "==========================="
    puts "  Welcome to Mastermind"
    puts "==========================="

    #sleep 1

    puts "Please enter your name:\n"
    player = gets.chomp
    @player = Player.new(player)
    puts "\n\n"
    #sleep 1
    puts "Thank you, #{player}."
    puts "\n\n"
    #sleep 1
  end

  def instructions
    puts "The Mastermind will create a code of four colors from this list:\n"
    puts "\n"
    #sleep 1
    self.list_colors
    #sleep 1
    puts "There may be more than one of a color in the code."
    #sleep 1
    puts "The Codebreaker will have 12 tries to guess the code.\n"
    #sleep 1
    puts "The Mastermind will return a hint in the form of black and white pegs.\n"
    #sleep 2
    puts "A black peg means a correct color in the correct place.\n"
    #sleep 2
    puts "A white peg means a correct color but in the wrong place.\n"
    #sleep 3
    puts "Would you like to be the Code Breaker or the Mastermind?\n"
    # sleep 1

    begin
      puts "Please enter 'codebreaker' or 'mastermind' below: \n"
      puts "Do not put quotation marks around the word."
      @human_role = gets.chomp.strip.join("")
      raise WrongInput if @human_role != "codebreaker" || @human_role != "mastermind"
    rescue WrongInput
      puts "Looks like you didn't enter 'codebreaker' or 'mastermind'.\n"
      puts "Remember not to use quotation marks.\n\n"
      retry
    end

    puts "\n\n"
  end

  def turn_count
    turns_remaining = 12 - @turns
    puts "This is turn #{@turns}."
    puts "You have #{turns_remaining} turns remaining."
    @turns += 1
  end

  def play
    until self.win? || self.lose?
      self.turn_count
      puts "\n"

      begin
        puts "Enter your guess of four colors (separated by commas):"
        guess = gets.chomp.gsub(/\s+/, "").split(",").map!(&:downcase)
        raise NotAColor if !(guess.all? { |color| COLORS.include?(color) })
        raise RepeatGuess if @guess_history.keys.include?(guess)
      rescue NotAColor
        puts "\n\n"
        puts "You entered something that wasn't a color!"
        #sleep 1
        puts "Remember to separate your colors with a comma."
        retry
      rescue RepeatGuess
        puts "\n\n"
        puts "...you already guessed that."
        #sleep 1
        puts "Your guess of '#{guess.join(", ")}' got #{@guess_history[guess]}"
        #sleep 1
        puts "Try again!"
        #sleep 1
        retry
      end

      self.check(guess)

      if self.win?
        self.congratulations
      elsif self.lose?
        self.sorry
      else
        self.give_hint
        self.store_guess_and_hint(guess)
        self.give_history
     end
    end
  end

  def check(guess)
    @exact_match = 0
    @color_match = 0

    hints = self.find_matches(guess, @code)
    @exact_match, @color_match = hints[0], hints[1]
  end

  def give_hint
    @hint = "#{@exact_match} black peg(s) and #{@color_match} white peg(s)."
    #sleep 1
  end

  def store_guess_and_hint(guess)
    @guess_history[guess] = @hint
  end

  def give_history
    puts "Past guesses:\n"
    #sleep 1
    self.guess_history.each do |guess, hint|
      puts "Guess: #{guess}"
      puts "Hint: #{hint}"
      puts "\n"
    end
  end

  def reveal_code
    if self.win? || self.lose?
      puts "This was the code:"
      puts @code.join(", ")
    elsif self.lose? == false
      @force_lose = true
      puts "This was the code:"
      @code.join(", ")
    end
  end

  def win?
    return true if @exact_match == 4
    false
  end

  def lose?
    @force_lose = false
    return true if @turns == 12 && self.win? == false
    return true if @force_lose
    false
  end

  def congratulations
    #sleep 1
    # Gem.win_platform? ? (system "cls") : (system "clear")
    10.times do
      puts "You guessed the correct code!\n\n"
      #sleep 0.25
    end
    self.reveal_code
  end

  def sorry
    #sleep 1
    # Gem.win_platform? ? (system "cls") : (system "clear")
    puts "I guess you are not a master mind!"
    #sleep 2
    self.reveal_code
  end

  protected

  def make_code
    4.times { @code << COLORS[rand(5)] }
  end

end

class Player
  include Tooling

  attr_accessor :name, :guess, :exact_match, :color_match
  attr_reader :code

  def initialize(name)
    @name = name
  end

  def make_code
    begin
      puts "You can make a code from these colors: "
      puts "#{COLORS.join(", ")}"
      puts "Enter your code of four colors (separated by commas):"
      Mastermind.code = gets.chomp.gsub(/\s+/, "").split(",").map!(&:downcase)
      raise NotAColor if !(guess.all? { |color| COLORS.include?(color) })
    rescue NotAColor
      puts "\n\n"
      puts "You entered something that wasn't a color!"
      #sleep 1
      puts "Remember to separate your colors with a comma."
      retry
    end
  end

  def give_hint
    puts "The AI has guessed:"
    ComputerAI.guess.join(", ")
    puts "Enter your hints below"
    puts "Exact matches:"
    @exact_match = gets.chomp
    puts "Color matches:"
    @color_match = gets.chomp
  end

end

class ComputerAI
  attr_reader :guess

  def initialize
    @guess = []
  end

  def make_guess
    4.times { @guess << COLORS[rand(5)] } if @guess.empty?
    if @exact_match > 0
      keep those colors and their place
    elsif @color_match > 0
      keep those colors
    end
  end
end

game = Mastermind.new
game.play

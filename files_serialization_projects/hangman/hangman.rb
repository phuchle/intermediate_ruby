# number of tries = "hangman".length
# secret_word = read a word from the 5desk.txt file
# hangman:
#   detects if there are any saves and asks to loads
#   loads any previous games => continues to play
#   need to list previous saves
#   use Dir.glob to list saves
#   saves games => saves right & wrong guesses, the word,
#   saves the player name, how many guesses they have left
#   -- picks a word
#   -- checks guesses against word
#   displays any guesses correct guesses in word
#   displays wrong guesses
#   -- displays how many guesses are left
#   -- shows win or loss
# player makes guesses
# player needs to be able to save at any point
# player can type 'save' to save the game


# errors
#   did not enter a letter
#   letter has already been guessed
require 'byebug'
require 'json'

module Tools
  class NotALetter < ArgumentError ; end
  class RepeatGuess < StandardError ; end
  class RepeatName < StandardError ; end
end

class Hangman
  include Tools

  attr_reader :secret_word, :concealed_secret_word

  def initialize
    @secret_word = self.select_word
    @concealed_secret_word = Array.new(@secret_word.length, "_")
    self.intro
    self.instructions
    @turns_remaining = @secret_word.length + 3
  end

  def select_word
    words_array = File.readlines("5desk.txt").select do |word|
      word.length > 5 && word.length < 12
    end

    words_array.sample.gsub(/\r\n/, "")
  end

  def intro
    Gem.win_platform? ? (system "cls") : (system "clear")

    puts "==========================="
    puts "    Welcome to Hangman"
    puts "==========================="

    #sleep 1

    puts "Please enter your name:\r\nThis will be used to save your game."
    player = gets.chomp
    @player = Player.new(player)
    #sleep 1
    puts "Thank you, #{player}.\n\n"
    #sleep 1
  end

  def instructions
    puts "You will have 7 chances to guess the correct letters in the secret word."
    puts "If you guess all letters, you win!  If not, you lose. :("
    puts "Good luck!\n\n"
  end

  def play
    until @turns_remaining == 0 || self.win?
      begin
        puts "What's your guess?\r"
        @guess = gets.chomp.downcase.to_s
        raise NotALetter if !@guess.match(/[a-z]/)
        raise RepeatGuess if @player.correct_guesses.include?(@guess) ||
                             @player.wrong_guesses.include?(@guess)
      rescue NotALetter
        puts "You didn't enter a letter!\nTry again below:\r\n"
        retry
      rescue RepeatGuess
        puts "You already guessed that!\r"
        retry
      end

      self.store_guess(@guess)
      self.give_hint(@guess)

      @turns_remaining -= 1
      puts "You have #{@turns_remaining} turns remaining.\n\n"

      if self.win?
        self.congratulations
      elsif @turns_remaining == 0
        self.sorry
      end
    end
  end

  def check_guess(guess)
    @secret_word.chars.any? { |char| char == guess }
  end

  def store_guess(guess)
    self.check_guess(guess) ? @player.correct_guesses << guess :
                              @player.wrong_guesses << guess
  end

  def give_hint(guess)
    if self.check_guess(@guess)
      @secret_word.chars.each_with_index do |letter, index|
        @concealed_secret_word[index] = letter if letter == guess
      end
    end

    puts "Secret Word: #{@concealed_secret_word.join(" ")}"
    puts "Wrong Guesses: #{@player.wrong_guesses.join(", ")}"
  end

  def win?
    @secret_word.chars.all? do |letter|
      @player.correct_guesses.include?(letter)
    end
  end

  def congratulations
    #sleep 1
    Gem.win_platform? ? (system "cls") : (system "clear")
    10.times do
      puts "You guessed the correct word!\n\n"
      #sleep 0.25
    end
  end

  def sorry
    #sleep 1
    Gem.win_platform? ? (system "cls") : (system "clear")
    puts "You lose :("
    puts "The word was #{@secret_word}."
    #sleep 2

  end

  def list_save_files
    # use Dir.glob
  end

  def save_game
    # serializes game
  end

  def load_game(file)
    # unserialize
  end
end

class Player
  attr_accessor :name, :correct_guesses, :wrong_guesses

  def initialize(name)
    @name = name
    @correct_guesses = []
    @wrong_guesses = []
  end

end

game = Hangman.new
game.play

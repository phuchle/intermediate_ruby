# number of tries = "hangman".length
# secret_word = read a word from the 5desk.txt file
# hangman:
#   detects if there are any saves and asks to loads
#   loads any previous games => continues to play
#   need to list previous saves
#   use Dir.glob to list saves
#   saves games => saves right & wrong guesses, the word,
#   saves the player name, how many guesses they have left
#   picks a word
#   checks guesses against word
#   displays any guesses correct guesses in word
#   displays wrong guesses
#   displays how many guesses are left
#   shows win or loss
# player makes guesses
# player needs to be able to save at any point
# player can type 'save' to save the game


# errors
#   did not enter a letter
#   letter has already been guessed
require 'json'

module Tools
  class NotALetter < ArgumentError ; end
  class RepeatGuess < StandardError ; end
  class RepeatName < StandardError ; end

end

class Hangman
  attr_reader :secret_word, :concealed_secret_word

  def initialize
    @secret_word = self.select_word
    @concealed_secret_word = Array.new(secret_word.length, "_")
    self.intro
    self.instructions
    @turns_remaining = "hangman".length
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
    puts "  Welcome to Hangman"
    puts "==========================="

    #sleep 1

    puts "Please enter your name:\n"
    puts "This will be used to save your game."
    player = gets.chomp
    @player = Player.new(player)
    puts "\n\n"
    #sleep 1
    puts "Thank you, #{player}."
    puts "\n\n"
    #sleep 1
  end

  def instructions
    puts "

    "
  end

  def play
    until @turns_remaining == 0 || self.win?
      # takes guess
      # checks guess
      # records guess in history
      # outputs right or wrong
      # outputs how many turns left
      # out puts past right and wrong guesses
      @turns_remaining -= 1
    end
  end

  def check_guess(letter)
    if SECRET_WORD.chars.any? { |char| char == letter }
      @player.correct_guesses << letter
    else
      @player.wrong_guesses << letter
    end
  end

  def win?
    true if correct_guesses.join("") == SECRET_WORD
    false
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

  def guess(letter)

  end
end

require 'byebug'
require './lib/save_game'
require './lib/load_game.rb'
require './lib/end_game.rb'

module Errors
  class NotALetter < ArgumentError ; end
  class TooManyLetters < ArgumentError ; end
  class RepeatGuess < StandardError ; end
  class RepeatName < StandardError ; end
  class DuplicateFile < StandardError ; end
  class WrongInput < StandardError ; end
end

class Hangman
  include Errors
  include SaveGame
  include LoadGame
  include EndGame

  attr_accessor :secret_word, :concealed_secret_word

  def initialize
    self.display_welcome_screen
    self.display_loading_screen
  end

  def select_word
    words_array = File.readlines("5desk.txt").select do |word|
      word.length > 5 && word.length < 12
    end

    words_array.sample.gsub(/\r\n/, "").downcase
  end

  def display_welcome_screen
    Gem.win_platform? ? (system "cls") : (system "clear")

    puts "==========================="
    puts "    Welcome to Hangman"
    puts "===========================\n\n"

    #sleep 1
  end

  def display_loading_screen
    puts "Would you like to load a previous save? (y/n)"
    load_save = gets.chomp

    if load_save == "y"
      puts "Enter a file name listed below to load previous save:"
      self.list_save_files
      file = gets.chomp

      self.load_game(file)
      self.display_instructions

      puts "Welcome back, #{@player.name}"
      self.give_hint(@guess)
    elsif load_save == "n"
      @secret_word = self.select_word
      @concealed_secret_word = Array.new(@secret_word.length, "_")
      @turns_remaining = @secret_word.length + 3

      self.get_player_name
      self.display_instructions
    end
  end

  def load?

  end


  def get_player_name
    puts "Please enter your name:\r\nThis will be used to save your game."
    player = gets.chomp
    @player = Player.new(player)
    #sleep 1
    puts "Thank you, #{player}.\n\n"
    #sleep 1
  end

  def display_instructions
    puts "You will have #{@turns_remaining} chances to guess the correct letters in the secret word."
    puts "If you guess all letters, you win!  If not, you lose. :("
    puts "Type \"S\" (without quotation marks) at any time to save the game."
    puts "Type \"L\" at any time to load a past game."
    puts "Good luck!\n\n"
  end

  def play
    until @turns_remaining == 0 || self.win?
      self.get_guess
      self.store_guess(@guess)
      self.give_hint(@guess)

      @turns_remaining -= 1 unless check_guess(@guess)
      puts "You have #{@turns_remaining} turns remaining.\n\n"

      if self.win?
        self.player_win_message
      elsif @turns_remaining == 0
        self.player_lose_message
      end
    end
  end

  def get_guess
    begin
      puts "What's your guess?\n"
      @guess = gets.chomp

      if @guess == "S" 
        # player_save = "#{@player.name}.json"
        self.save_game
        self.successful_save?
      end

      @guess.downcase!

      raise NotALetter if @guess.length > 1 && !@guess.match(/[a-zA-Z]/)
      raise RepeatGuess if @player.correct_guesses.include?(@guess) ||
                           @player.wrong_guesses.include?(@guess)
    rescue NotALetter
      puts "You didn't enter just one letter!\nTry again below:\r\n"
      retry
    rescue RepeatGuess
      puts "You already guessed that!\n"
      retry
    end
  end

  def check_guess(guess)
    @secret_word.chars.any? { |char| char == guess }
  end

  def store_guess(guess)
    if self.check_guess(guess)
      @player.correct_guesses << guess
    else
      @player.wrong_guesses << guess
    end
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

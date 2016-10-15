# number of tries = "hangman".length + 3 (to make it easier)
# secret_word = read a word from the 5desk.txt file
# hangman:
#   detects if there are any saves and asks to loads
#   loads any previous games => continues to play
#   -- need to list previous saves
#   -- use Dir.glob to list saves
#   -- saves games => saves right & wrong guesses, the word,
#   --saves the player name, how many guesses they have left
#   -- picks a word
#   -- checks guesses against word
#   -- displays any guesses correct guesses in word
#   -- displays wrong guesses
#   -- displays how many guesses are left
#   -- shows win or loss
# player makes guesses
# player needs to be able to save at any point
# player can type 'save' to save the game

require 'byebug'
require 'json'

module Tools
  class NotALetter < ArgumentError ; end
  class TooManyLetters < ArgumentError ; end
  class RepeatGuess < StandardError ; end
  class RepeatName < StandardError ; end
  class DuplicateFile < StandardError ; end
  class WrongInput < StandardError ; end
end

class Hangman
  include Tools

  attr_reader :secret_word, :concealed_secret_word

  def initialize
    @save_dir = "save-files"
    
    self.welcome_screen
    self.loading_screen
    # self.play
  end

  def select_word
    words_array = File.readlines("5desk.txt").select do |word|
      word.length > 5 && word.length < 12
    end

    words_array.sample.gsub(/\r\n/, "")
  end

  def welcome_screen
    Gem.win_platform? ? (system "cls") : (system "clear")

    puts "==========================="
    puts "    Welcome to Hangman"
    puts "===========================\n\n"

    #sleep 1
  end

  def loading_screen
    puts "Would you like to load a previous save? (y/n)"
    load_save = gets.chomp

    if load_save == "y"
      puts "Enter a file name listed below to load previous save:"
      self.list_save_files
      file = gets.chomp

      self.load_game(file)
      self.instructions

      puts "Welcome back, #{@player.name}"
      self.give_hint(@guess)
    elsif load_save == "n"
      @secret_word = self.select_word
      @concealed_secret_word = Array.new(@secret_word.length, "_")
      @turns_remaining = @secret_word.length + 3

      self.get_player_name
      self.instructions
    end
  end

  def get_player_name
    puts "Please enter your name:\r\nThis will be used to save your game."
    player = gets.chomp
    @player = Player.new(player)
    #sleep 1
    puts "Thank you, #{player}.\n\n"
    #sleep 1
  end

  def instructions
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

      @turns_remaining -= 1
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

  def win?
    @secret_word.chars.all? do |letter|
      @player.correct_guesses.include?(letter)
    end
  end

  def player_win_message
    #sleep 1
    Gem.win_platform? ? (system "cls") : (system "clear")

    10.times do
      puts "You guessed the correct word!\n\n"
      #sleep 0.25
    end
  end

  def player_lose_message
    #sleep 1
    Gem.win_platform? ? (system "cls") : (system "clear")

    puts "You lose :("
    puts "The word was #{@secret_word}."
    #sleep 2

  end

  def list_save_files
    puts Dir.glob("#{@save_dir}/*.json")
  end

  def save_game
    @file = "#{@player.name}.json"
    serialized_instance_variables = self.serialize_instance_variables

    Dir.mkdir(@save_dir) unless Dir.exist?(@save_dir)

    begin
      if File.exist?("#{@save_dir}/#{@file}")
        raise DuplicateFile
      else
        new_save = File.open("#{@save_dir}/#{@file}", "w")
        new_save.write(serialized_instance_variables)
        new_save.close
      end

    rescue DuplicateFile
      puts "A save file with your name already exists!"

      begin
        puts "Do you want to replace the file with your new one? (yes/no)"

        answer = gets.chomp
        raise WrongInput if !answer.match(/yes|no/)
      rescue WrongInput
        retry
      end

      if answer == "yes"
        new_save = File.open("#{@save_dir}/#{@file}", "w")
        new_save.write(serialized_instance_variables)
        new_save.close
      else
        puts "These are the current save files:"
        self.list_save_files

        puts "Please enter a new name to save your game."
        @player.name = gets.chomp
        self.save_game
      end
    end
  end

  def successful_save?
    if File.exist?("#{@save_dir}/#{@file}")
      puts "The game has been successfully saved!\n\n"
    else
      puts "Something went wrong!\n\n"
    end
  end

  def serialize_instance_variables
    JSON.dump ({
      :hangman => {
        :secret_word => @secret_word,
        :concealed_secret_word => @concealed_secret_word,
        :turns_remaining => @turns_remaining  
      },
      :player => {
        :name => @player.name,
        :correct_guesses => @player.correct_guesses,
        :wrong_guesses => @player.wrong_guesses
      }
    })
  end

  def append_file_extension(file)
    file += ".json"
  end

  def load_game(file) #TODO file needs to be converted to append json 
    game_instance_variables = File.open("#{@save_dir}/#{file}", "r") do |file|
      file.read
    end
    parsed_game_instance_variables = JSON.parse(game_instance_variables)

    # TODO @instance_variables_to_save showing up as nil 
    hangman_variables = parsed_game_instance_variables["hangman"]
    @secret_word = hangman_variables["secret_word"]
    @concealed_secret_word = hangman_variables["concealed_secret_word"]
    @turns_remaining = hangman_variables["turns_remaining"]

    # below this line works
    @player = Player.new(
      parsed_game_instance_variables["player"]["name"]
      )
    @player.correct_guesses = parsed_game_instance_variables["player"]["correct_guesses"]
    @player.wrong_guesses = parsed_game_instance_variables["player"]["wrong_guesses"]
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

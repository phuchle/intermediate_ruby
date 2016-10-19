require 'json'

module LoadGame
  def list_save_files
    puts "These are the current save files:"
    puts Dir.glob("save-files/*.json")
  end

  def load_game(file) #TODO file needs to be converted to append json 
    game_instance_variables = File.read("save-files/#{file}")
    parsed_game_instance_variables = JSON.parse(game_instance_variables)

    load_hangman_variables(parsed_game_instance_variables)
    load_player_variables(parsed_game_instance_variables)
  end

  def load_hangman_variables(parsed_game_instance_variables)
    hangman_variables = parsed_game_instance_variables["hangman"]

    @secret_word = hangman_variables["@secret_word"]
    @concealed_secret_word = hangman_variables["@concealed_secret_word"]
    @turns_remaining = hangman_variables["@turns_remaining"]
  end

  def load_player_variables(parsed_game_instance_variables)
    player_variables = parsed_game_instance_variables["player"]

    @player = Player.new(player_variables["@name"])
    @player.correct_guesses = player_variables["@correct_guesses"]
    @player.wrong_guesses = player_variables["@wrong_guesses"]
  end
end
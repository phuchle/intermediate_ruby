require 'json'

module LoadGame
  def load_game(file) #TODO file needs to be converted to append json 
    game_instance_variables = File.read("save-files/#{file}")
    parsed_game_instance_variables = JSON.parse(game_instance_variables)

    load_hangman_variables(parsed_game_instance_variables)
    load_player_variables(parsed_game_instance_variables)
  end

  def load_hangman_variables(parsed_game_instance_variables)
    hangman_variables = parsed_game_instance_variables["hangman"]
    @secret_word = hangman_variables["secret_word"]
    @concealed_secret_word = hangman_variables["concealed_secret_word"]
    @turns_remaining = hangman_variables["turns_remaining"]
  end

  def load_player_variables(parsed_game_instance_variables)
    @player = Player.new(parsed_game_instance_variables["player"]["name"])
    @player.correct_guesses = parsed_game_instance_variables["player"]["correct_guesses"]
    @player.wrong_guesses = parsed_game_instance_variables["player"]["wrong_guesses"]
  end
end
require 'json'

module SaveGame
  player_save = "#{@player.name}.json"
  def save_game
    serialized_instance_variables = self.serialize_instance_variables

    Dir.mkdir("save-files") unless Dir.exist?("save-files")

    begin
      if File.exist?("save-files/#{player_save}")
        raise DuplicateFile
      else
        new_save = File.open("save-files/#{player_save}", "w")
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

      overwrite_save_file?(answer)
    end

  end

  def overwrite_save_file?(answer)
    if answer == "yes"
      File.open("save-files/#{player_save}", "w") do |new_savesave|
        new_save.write(serialized_instance_variables)
      end
    else
      puts "These are the current save files:"
      self.list_save_files

      puts "Please enter a new name to save your game."
      @player.name = gets.chomp
      self.save_game
    end
  end

  def successful_save?
    if File.exist?("save-files/#{player_save}")
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

end

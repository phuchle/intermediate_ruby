require 'json'

module SaveGame
  def save_game
    serialized_instance_variables = self.serialize_instance_variables

    Dir.mkdir("save-files") unless Dir.exist?("save-files")

    begin
      if File.exist?("save-files/#{@player.name}.json")
        raise DuplicateFile
      else
        new_save = File.open("save-files/#{@player.name}.json", "w")
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
      File.open("save-files/#{@player.name.json}", "w") do |new_savesave|
        new_save.write(serialized_instance_variables)
      end
    else
      puts "These are the current save files:"
      self.list_save_files

      puts "Please enter a new name to save your game."
      @player.name = gets.chomp + ".json"
      self.save_game(@player.name)
    end
  end

  def successful_save?
    if File.exist?("save-files/#{@player.name}")
      puts "The game has been successfully saved!\n\n"
    else
      puts "Something went wrong!\n\n"
    end
  end

  def serialize_instance_variables
    save_variables = {}
    self.instance_variables.each do |var|
      save_variables[var] = self.instance_variable_get(var)
    end

    @player.instance_variables.each do |var|
      save_variables["player"][var] = @player.instance_variable_get(var)
    end

    save_variables.to_json
  end

end

module EndGame
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
end

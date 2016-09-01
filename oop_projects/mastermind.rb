class Mastermind
  def initialize(player)
    @player = Player.new(player)
    @colors = %w(red orange yellow green blue violet)
    self.make_code
  end

  def check(guess)
    @exact_match = 0
    @color_match = 0

    self.find_matches(guess, @code)
  end

  def find_matches(guess, code)
    guess.each_with_index do |guess_color, guess_index|
      code.each_with_index do |code_color, code_index|
        if guess_color == code_color && guess_index == code_index
          @exact_match += 1
        elsif guess_color == code_color && guess_index != code_index
          @color_match += 1 if @color_match < code.count(code_color) #do not overcount
        end
      end
    end
  end

  def hint
    puts "#{@exact_match} black peg(s) and #{@color_match} white peg(s)."
  end

  def response(guess)
    self.check(guess)
    self.hint
  end

  protected

  def make_code
    @code = []
    4.times { @code << @colors[rand(5)] }
  end
end

Player = Struct.new(:name, :guess)

#################

game = Mastermind.new("Phuc")

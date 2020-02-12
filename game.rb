class Game
  require "./board"
  require "./computer"
  require "./player"
  DEFAULT_COLORS = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]

  def initialize(colors = DEFAULT_COLORS[0..3], code_length = 4)
    @colors = colors
    @code_length = code_length
    @board = Board.new(code_length)
    @computer = Computer.new(colors, code_length)
    @player = Player.new(colors, code_length)
    @game_over = false
    @is_codemaker = false
  end

  def run_game
    is_codemaker = @player.codemaker?
    
    if @is_codemaker
      puts "Think of a #{code_length} color combination of #{@colors.join(", ")}"
      puts "Press enter when ready."
      input = gets.chomp
      until @game_over
        @computer.guess
      end
    else
      @computer.select_random_code(@code_length)
      puts "The devious computer mastermind has a #{@code_length} color combination of #{@colors.join(", ")}"
      puts "C = Correct guess and position, / = Wrong position, X = Wrong guess"
      until @game_over
        @board.show
        guess = @player.guess
        @board.add(guess, @computer.get_feedback(guess))
        if @board.win?
          @board.show
          puts "You win!"
          @game_over = true
        end
      end
    end
  end
end

game = Game.new
game.run_game
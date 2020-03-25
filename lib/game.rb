class Game
  require_relative 'board'
  require_relative 'computer'
  require_relative 'player'

  attr_reader :code_length, :colors, :is_codemaker, :board, :computer
  attr_accessor :turn, :new_guess

  DEFAULT_COLORS = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]

  def initialize(options = {num_colors: 4, code_length: 4, is_codemaker: false})
    
    @colors = DEFAULT_COLORS[0...options[:num_colors].to_i]
    @code_length = options[:code_length].to_i
    @is_codemaker = (options[:is_codemaker].to_s == 'true')
    @game_over = false
    @board = Board.new(@code_length, options[:guesses], options[:feedback])
    @computer = Computer.new(@colors, @code_length, options[:code], options[:last_guess])
    @turn = options[:turn].to_i
  end

  def view_variables
    {
      code_length: @code_length, 
      colors: @colors,
      colors_list: to_sentence(@colors),
      is_codemaker: @is_codemaker,
      # computer: @computer,
      board: @board,
      turn: @turn,
      new_guess: @new_guess
    }
  end

  def session_variables
    {
      code_length: @code_length, 
      num_colors: @colors.length,
      is_codemaker: @is_codemaker,
      turn: @turn,
      guesses: @board.guesses,
      feedback: @board.feedback
    }
  end

  def run_game
    settings = @player.choose_difficulty
    create_game(DEFAULT_COLORS[0...settings[:num_colors]], settings[:code_length])

    @is_codemaker = @player.codemaker?
    
    if @is_codemaker
      play_as_codemaker
    else
      play_as_codebreaker
    end
  end

  def play_as_codemaker
    puts "Think of a #{@code_length} color combination of #{@colors.join(", ")}"
    puts "Press enter when ready."
    input = gets.chomp
    until @game_over
      @board.add(@computer.guess)
      @board.show
      feedback = @player.give_feedback
      @computer.calculate(feedback)
      @board.add_feedback(feedback)
      if @board.win?
        @board.show
        puts "Computer wins!"
        @game_over = true
      elsif @computer.mistake?
        @game_over = true
      end
    end
  end

  def play_as_codebreaker
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

  def to_sentence(arr)
    arr = arr.to_a
    words_connector     = ", "
    two_words_connector = " and "
    last_word_connector = ", and "

    case arr.length
      when 0
        ""
      when 1
        arr[0].to_s.dup
      when 2
        "#{arr[0]}#{two_words_connector}#{arr[1]}"
      else
        "#{arr[0...-1].join(words_connector)}#{last_word_connector}#{arr[-1]}"
    end
  end
end


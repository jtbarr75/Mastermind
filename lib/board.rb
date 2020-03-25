class Board
  attr_reader :guesses, :feedback

  PEGS = {
            "Empty" => 'images/black_dot.jpg',
            "Red" => 'images/red_dot.jpg',
            "Orange" => 'images/orange_dot.jpg',
            "Yellow" => 'images/yellow_dot.jpg',
            "Green" => 'images/green_dot.jpg',
            "Blue" => 'images/blue_dot.jpg',
            "Purple" => 'images/purple_dot.jpg',
            "X" => 'images/black_dot_small.jpg',
            "/" => 'images/grey_dot_small.jpg',
            "C" => 'images/white_dot_small.jpg'
          }

  def initialize(code_length, guesses, feedback)
    @code_length = code_length
    @guesses = guesses ? guesses : Array.new(12, [])
    @feedback = feedback.to_a
    @blank_feedback = []
    code_length.times do
      @blank_feedback.push("X")
    end
  end

  def add(guess, turn, feedback = @blank_feedback)
    @guesses[turn] = guess
    @feedback[turn] = feedback
  end

  def add_feedback(turn, feedback)
    @feedback[turn] = feedback
  end

  def last_feedback
    @feedback[-1]
  end

  def win?
    @feedback.last.all?{|e| e == "C"} unless @feedback.empty?
  end

  def pegs 
    PEGS
  end
end
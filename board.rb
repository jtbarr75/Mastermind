class Board
  def initialize
    @guesses = [[]]
    @blank_feedback = []
    @feedback = []
  end

  def set_values(code_length)
    code_length.times do
      @guesses[0].push("____")
      @blank_feedback.push("_")
    end
    @feedback.push(@blank_feedback)
    @board_width = code_length * 7
  end

  def show
    @guesses.each_with_index do
       |line, index| print "#{line.join(", ").ljust(@board_width) } | #{@feedback[index].join(" ")}\n\n" 
    end
  end

  def add(guess, feedback = @blank_feedback)
    @guesses.push(guess)
    @feedback.push(feedback)
  end

  def add_feedback(feedback)
    @feedback[-1] = feedback
  end

  def last_feedback
    @feedback[-1]
  end

  def win?
    @feedback.last.all?{|e| e == "C"}
  end
end
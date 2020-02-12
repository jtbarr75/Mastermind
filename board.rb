class Board
  def initialize(code_length)
    @guesses = [[]]
    @feedback = [[]]
    code_length.times do
      @guesses[0].push("____")
      @feedback[0].push("_")
    end
    @board_width = code_length * 7
  end

  def show
    @guesses.each_with_index do
       |line, index| print "#{line.join(", ").ljust(@board_width)} | #{@feedback[index].join(" ")}\n\n" 
    end
    
  end

  def add(guess, feedback)
    @guesses.push(guess)
    @feedback.push(feedback)
  end

  def win?
    @feedback.last.all?{|e| e == "C"}
  end
end
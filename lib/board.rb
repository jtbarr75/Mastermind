class Board
  attr_reader :guesses, :feedback

  PEGS = {
            "Empty" => 'https://vectr.com/jtbarr/c8C1OtgIZ.jpg?width=20&height=20&select=c8C1OtgIZpage0',
            "Red" => 'https://vectr.com/jtbarr/epERYUu1y.jpg?width=20&height=20&select=epERYUu1ypage0',
            "Orange" => 'https://vectr.com/jtbarr/f1hdgU4rtc.jpg?width=20&height=20&select=f1hdgU4rtcpage0',
            "Yellow" => 'https://vectr.com/jtbarr/bX1gDdejR.jpg?width=20&height=20&select=bX1gDdejRpage0',
            "Green" => 'https://vectr.com/jtbarr/f1i0gpytkL.jpg?width=20&height=20&select=f1i0gpytkLpage0',
            "Blue" => 'https://vectr.com/jtbarr/b4FRO5n9rj.jpg?width=20&height=20&select=b4FRO5n9rjpage0',
            "Purple" => 'https://vectr.com/jtbarr/a5QAPh0EA.jpg?width=20&height=20&select=a5QAPh0EApage0',
            "X" => 'https://vectr.com/jtbarr/b3VDIg8sBW.jpg?width=10&height=10&select=b3VDIg8sBWpage0',
            "/" => 'https://vectr.com/jtbarr/d417OpI5k.jpg?width=10&height=10&select=d417OpI5kpage0',
            "C" => 'https://vectr.com/jtbarr/a4gr7p5Wcz.jpg?width=10&height=10&select=a4gr7p5Wczpage0'
          }

  def initialize
    @guesses = Array.new(12, [])
    @blank_feedback = []
    @feedback = []
  end

  def set_values(code_length)
    @code_length = code_length
    code_length.times do
      @blank_feedback.push("X")
    end
    # @feedback.push(@blank_feedback)
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
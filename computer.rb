class Computer
  attr_reader :code

  def initialize(colors, code_length)
    @colors = colors
    @code = select_random_code(code_length)
    @code_length = code_length
    @color_incedence = @colors.map{|k| [k, 0]}.to_h
    #@code = ["Red", "Green", "Blue", "Red"]
  end

  def select_random_code(code_length)
    @code = []
    code_length.times { code.push(@colors[rand(@colors.length)]) }
  end

  def get_feedback(guess, code = @code)
    feedback = []
    @color_incedence = code.group_by{|e| e}.map{|k, v| [k, v.length]}.to_h
    guess.each_with_index do |color, index|
      if color == code[index]
        feedback[index] = "C"
        @color_incedence[color] -= 1
      else
        feedback[index] = "X"
      end
    end
    guess.each_with_index do |color, index|
      if @color_incedence[color] && @color_incedence[color] > 0 && feedback[index] != "C"
        feedback[index] = "D"
        @color_incedence[color] -= 1
      end
    end
    feedback.sort!.map! { |f| f.sub("D","/") }
    feedback
  end

  def guess
    @possible_codes = @colors.repeated_permutation(4).to_a unless @possible_codes
    @last_guess = @possible_codes[0]
    @possible_codes.shift
    puts @possible_codes.length
    @last_guess
  end

  def calculate(feedback)
    @possible_codes.select! do |possible_code|
      possible_feedback = get_feedback(@last_guess, possible_code)
      possible_feedback == feedback
    end
  end
end
class Computer
  attr_reader :code

  def initialize
  end

  def set_values(colors, code_length)
    @colors = colors
    @code = select_random_code(code_length)
    @code_length = code_length
    @color_incedence = @colors.map{|k| [k, 0]}.to_h
  end

  def select_random_code(code_length)
    @code = []
    code_length.times { code.push(@colors[rand(@colors.length)]) }
  end

  def get_feedback(guess, code = @code)
    feedback = []
    guess = guess.clone
    @color_incedence = code.group_by{|e| e}.map{|k, v| [k, v.length]}.to_h
    guess.each_with_index do |color, index|
      if color == code[index]
        guess[index] = "FOUND"
        feedback.push("C")
        @color_incedence[color] -= 1
      end
    end
    guess.each do |color|
      if @color_incedence[color] && @color_incedence[color] > 0
        feedback.push("/")
        @color_incedence[color] -= 1
      end
    end
    feedback.push("X") until feedback.length == guess.length
    feedback
  end

  def guess
    @possible_codes = @colors.repeated_permutation(@code_length).to_a unless @possible_codes
    @last_guess = @possible_codes[0]
    @possible_codes.shift
    @last_guess
  end

  def calculate(feedback)
    @possible_codes.select! do |possible_code|
      possible_feedback = get_feedback(@last_guess, possible_code)
      possible_feedback == feedback
    end
  end

  def mistake?
    if @possible_codes == []
      puts "No possible code satisfies these constraints. You messed up somewhere."
      return true
    end
    false
  end
end
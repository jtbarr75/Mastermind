class Computer
  attr_reader :code

  def initialize(colors, code_length)
    @colors = colors
    @code = select_random_code(code_length)
    #@code = ["Red", "Green", "Blue", "Red"]
  end

  def select_random_code(code_length)
    @code = []
    code_length.times { code.push(@colors[rand(@colors.length)]) }
  end

  def get_feedback(guess)
    feedback = []
    color_incedence = @code.group_by{|e| e}.map{|k, v| [k, v.length]}.to_h
    guess.each_with_index do |color, index|
      if color == @code[index]
        feedback[index] = "C"
        color_incedence[color] -= 1
      else
        feedback[index] = "X"
      end
    end
    guess.each_with_index do |color, index|
      if color_incedence[color] && color_incedence[color] > 0 && feedback[index] != "C"
        feedback[index] = "D"
        color_incedence[color] -= 1
      end
    end
    feedback.sort!.map! { |f| f.gsub("D","/") }
    feedback
  end

  def guess

  end
end
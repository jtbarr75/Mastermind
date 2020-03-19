class Player

  def set_values(colors, code_length)
    @colors = colors
    @code_length = code_length
  end

  #Prompts player for a code with correct colors and length
  def guess
    puts "Guess the code: (color, color, color, color)\n"
    guess = gets.chomp
    valid_input = false
    until valid_input
      guesses = guess.split(", ").map(&:capitalize)
      if guesses.length != @code_length 
        puts "Please give a list of #{@code_length} elements seperated by commas."
        guess = gets.chomp
      elsif guesses.all? { |str| @colors.include?(str) }
        valid_input = true
      else
        puts "Please give a list of #{@code_length} elements seperated by commas."
        guess = gets.chomp
      end
    end
    guesses
  end

  #Asks player if they want to make the code or guess computer's code
  def codemaker?
    choice = get_specific_input(
      "Do you want to be 1. Codemaker or 2. Codebreaker?",
      "Please choose 1 or 2"
    ) { |value| value == "1" || value == "2" }
    
    choice == 1
  end

  #Prompts player for feedback on how correct the computer's guess was
  def give_feedback
    correct_colors = get_specific_input(
      "How many colors are in the correct position?",
      "Please give the number of colors in the correct position."
    ) { |value| value.to_i.between?(0,@code_length) }
    
    misplaced_colors = get_specific_input(
      "How many colors are in your code but in the wrong position?",
      "Please give the number of colors that in your code, but in the wrong position."
    ) { |value| value.to_i.between?(0,@code_length - correct_colors.to_i) }
    
    feedback = []
    correct_colors.to_i.times { feedback.push("C") }
    misplaced_colors.to_i.times { feedback.push("/") }
    feedback.push("X") until feedback.length == @code_length
    feedback
  end

  #Prompts player for number of colors, length of code
  def choose_difficulty
    game_settings = {}
    game_settings[:num_colors] = get_specific_input(
      "Choose how many color choices you'd like: (2-6). More colors is more difficult.",
      "Please choose a number between 2 and 6."
    ) { |value| value.to_i.between?(2, 6) }
    game_settings[:code_length] = get_specific_input(
      "Choose how long you'd like the code to be: (2-6). Longer codes are more difficult.",
      "Please choose a number between 2 and 6."
    ) { |value| value.to_i.between?(2,6) }
    game_settings
  end

  #Prompts player for input that satisfies a condition in given block, repeats until satisfied
  def get_specific_input(prompt, repeat_prompt)
    puts prompt
    value = gets.chomp
    until yield(value)
      puts repeat_prompt
      value = gets.chomp
    end
    value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/ ? value.to_i : value
  end
end
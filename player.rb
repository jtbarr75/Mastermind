class Player

  def initialize(colors, code_length)
    @colors = colors
    @code_length = code_length
  end

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

  def codemaker?
    puts "Do you want to be 1. Codemaker or 2. Codebreaker?"
    choice = gets.chomp
    until choice == "1" || choice == "2"
      puts "Please choose 1 or 2"
      choice = gets.chomp
    end
    choice == "1"
  end
end
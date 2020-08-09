class Board
  attr_accessor :game_board
  def initialize
    @game_board=["", "", "", ""]
  end
end

class Error
  def self.char_count_error(user_guess)
    puts user_guess.length < 4 ? "Please enter at lease 4 characters" : "Please enter no more than 4 characters"
  end

  def self.unique_chars_error(user_guess)
    dups = user_guess.chars.group_by{|e| e}.keep_if{|_, e| e.length > 1}
    dups.keys.each {|d| puts "#{d} -> duplicated!"}
  end
end


class Game
  attr_reader :board, :computer_selection, :attempts, :points, :guesser, :mode, :computer
  def initialize (player1, computer)
    @@player1=player1
    @@computer="Hal-9000"
    @board=Board.new
    @points = {}
    @attempts = 1
    @mode = 0
    @@color_choices = ['R', 'O', 'Y', 'G', 'B', 'W']
    @computer_guesses = []
  end

  
  def start
    puts "Welcome to Mastermind, would you like to make or break the code?
          1. Break the code
          2. Make the code"
    @mode = gets.chomp.to_i until @mode == 1 || @mode == 2

    if @mode == 1
      play_game
    else
      CompMode.intro
    end
  end

  def breaker_intro
    puts"Welcome to mastermind, place your guesses\n\nThe options are:\n['R', 'O', 'Y', 'G', 'W', 'B']\n "
  end

  private
  def computer_options
     @computer_selection = @@color_choices.sample(4)
  end

  def play_game
    breaker_intro
    computer_options
    guesser
    hints
  end

  def error_check(user_guess)

      puts "\nPlease input characters from #{@@color_choices}" unless user_guess.chars.all? {|c| %w{r o y g b w}.include? c}
      if user_guess.length != 4
        Error.char_count_error(user_guess)
        @attempts -= 1 unless @attempts < 1
      end
      if user_guess.split.uniq.length != user_guess
        Error.unique_chars_error(user_guess)
      end
  end

  def user_guess_check(user_guess, computer_selection, points)
    user_guess.split('').each_with_index do |letter, i|
      if letter.upcase == computer_selection[i]
        points[:all_correct] += 1 
      elsif computer_selection.include?(letter.upcase)
        points[:color_exist] += 1 unless computer_selection[i] == letter
      end
    end
  end

  def guesser
    while @attempts <= 10
      puts "\nAttempt # #{attempts}"
      user_guess=gets.chomp
      points=Hash.new(0)

      error_check(user_guess)
      user_guess_check(user_guess, computer_selection, points)

      if points[:all_correct] == board.game_board.length
        puts "Winner Winner Chicken Dinner!"
        puts "\nThe code was #{computer_selection}"
        break
      end

      if @attempts > 9 && points[:all_correct] != board.game_board.length
        puts "\nWhat a sad day for humanity...\n#{@@computer} is the winner."
        break
      end
      puts points unless points == {}
      @attempts+=1
    end
  end

  def hints
    puts points unless points == {}
  end
end

class CompMode < Game
  def self.intro
    puts "\nWelcome to Maker Mode\nTo begin, set 4 colors from the array below\nYour choices are:\n#{@@color_choices}"
    play_against_ai
  end

  def self.play_against_ai
    set_colors
    program_ai(@@code)
  end

  def self.set_colors
    puts "Please enter 4 colors now"
    @@code = gets.chomp.upcase.split('')
    until @@code.length <= 4
      puts "Please enter a 4 letter code."
      @@code = gets.chomp.upcase.split('')
    end
    p @@code
  end

  def self.program_ai(code)
    puts "#\n\n#{@@computer} has 10 attempts to guess your code"
    @computer_guesses = []
    @reuse_colors = []
    @attempts = 1
    while @attempts < 11

      puts "Press ENTER to continue..."
      gets
      @attempts += 1
      random_guess1 = @@color_choices.sample(4)
      verify_colors(random_guess1, @computer_guesses)

      reuse_colors(random_guess1, @computer_guesses, @reuse_colors)
      computer_check_combo(random_guess1, @computer_guesses, @reuse_colors)
      puts "Hal knows:"
      p verify_colors(random_guess1, @computer_guesses) unless nil
      puts "\nHal has tried #{@attempts} times to crack the code."

    end
    puts "\nAhh...\nToday we are safe."
  end

  def self.computer_check_combo(random_guess1, computer_guesses, reuse_colors)
    i = 0
    until i == 4
      if random_guess1 == @@code
        p random_guess1
        puts "Sorry #{@@player1}. I'm going to have to terminate you..."
        exit!
      elsif computer_guesses == @@code
        p computer_guesses
        puts "Sorry #{@@player1}. I'm going to have to terminate you..."
        computer_guesses
        exit!
      elsif random_guess1[i] == @@code[i]
        computer_guesses[i] = @@code[i]
        i += 1
      elsif @@code.include?(random_guess1[i]) && computer_guesses != @@code[i]
        reuse_colors.push(random_guess1[i])
        i += 1
      else
        i += 1
      end
    end
    puts "Hal guessed:"
    p random_guess1
  end
end

  def verify_colors(random_guess1, computer_guesses)
    computer_guesses.each_with_index { |color, index| random_guess1[index] = color if %w(r o y g b w).include?(color)}
  end

  def reuse_colors(random_guess1, computer_guesses, reuse_colors)
    computer_guesses.each_with_index do |color, index|
      if random_guess1.include?(color) && random_guess1[index] != color
        random_guess1[index] = reuse_colors[rand(0..reuse_colors.length)]
      end
    end
  end

mastermind=Game.new('Henry', 'Hal-9000')
mastermind.start

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
  attr_accessor :board, :computer_selection, :points, :guesser, :attempts, :mode, :computer
  def initialize (player1, computer)
    @@player1=player1
    @@computer="Hal-9000"
    @board=Board.new
    @points = {}
    @attempts = 1
    @mode = 0
    @@color_choices = ['R', 'O', 'Y', 'G', 'B', 'W']
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
      %w(r o y g b w) 

      if user_guess.length != 4
        Error.char_count_error(user_guess)
        @attempts -= 1 unless @attempts < 1
      end

      if user_guess.split.uniq.length != user_guess
        Error.unique_chars_error(user_guess)
        @attempts -= 1 unless @attempts < 1
      end
      @attempts += 1
  end

  def guesser
    while @attempts < 11
      puts "\nAttempt # #{attempts}"
      user_guess=gets.chomp
      points=Hash.new(0)

      error_check(user_guess)

      user_guess.split('').each_with_index do |letter, i|
        if letter.upcase == computer_selection[i]
          points[:all_correct] += 1
        elsif computer_selection.include?(letter.upcase)
          points[:color_exist] += 1
        end
      end

      if points[:all_correct] == board.game_board.length
        puts "Chicken Dinner!"
        break
      end

      puts points unless points == {}
      @attempts+=1
    end
    puts "\nWhat a sad day for humanity...\n#{@@computer} is the winner."
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
    p @@code
  end

  def self.program_ai(code)
    #sleep(2) 
    puts "#\n\n#{@@computer} has 10 attempts to guess your code"
    @attempts = 1

    while @attempts < 10
    points = Hash.new(0)
    # sleep(0.1)
    answer = []
    random_guess1 = @@color_choices.sample(4)

      random_guess1.each_with_index do |letter, i|
        if letter.upcase == code[i]
          points[:all_correct] += 1
        end
    

        if points[:all_correct] == 4
          puts "#{@@computer} is the winner.\n\n\n#{@@computer}: I'm sorry #{@@player1}... "
          break
        end
      end

    @attempts += 1
    puts "\nAttempts # #{@attempts}"
    p random_guess1
    p points unless points == {}
    end
    puts "\nNot so smart afer all, huh?"
  end
end

mastermind=Game.new('Henry', 'Hal-9000')
mastermind.start


#  user_guess.split('').each_with_index do |letter, i|
#         if letter.upcase == computer_selection[i]
#           points[:all_correct] += 1
#         elsif computer_selection.include?(letter.upcase)
#           points[:color_exist] += 1
#         end
#       end
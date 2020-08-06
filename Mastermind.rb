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
  attr_accessor :board, :computer_selection, :points, :guesser, :attempts, :color_choices, :error_time
  def initialize (player1, computer)
    @player1=player1
    @computer=computer
    @board=Board.new
    @points = {}
    @attempts=1
    @error_time = error_time
    puts"Welcome to mastermind, place your guesses\n\nThe options are:\n['R', 'O', 'Y', 'G', 'B', 'W', 'B']\n "
  end

  def computer_options
     @color_choices = ['R', 'O', 'Y', 'G', 'B', 'W']
     @computer_selection = @color_choices.sample(4)
  end
  

  def play_game
    computer_options
    guesser
    hints
  end

  def error_check(user_guess)
      puts "\nPlease input characters from #{@color_choices}" unless user_guess.chars.all? {|c| %w{r o y g b w}.include? c}
      %w(r o y g b w) 
      user_guess

      if user_guess.length != 4
        Error.char_count_error(user_guess)
        @attempts -= 1 unless @attempts < 1
      end

      if user_guess.split.uniq.length != user_guess
        Error.unique_chars_error(user_guess)
        @attempts -= 1 unless @attempts < 1
      end
  end

  def guesser
    while @attempts < 10
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
      attempts
    end
  end

  def hints
    puts points
  end
end

mastermind=Game.new('Henry', 'Hal')
mastermind.play_game
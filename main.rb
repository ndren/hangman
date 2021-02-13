# frozen_string_literal: true

class Game
  attr_reader :lives, :word
  attr_accessor :guesses

  def initialize(guesses = [], lives = 7)
    @guesses = guesses
    @lives = lives
  end

  def pick_random_word
    @word = ''
    @word = File.readlines('5desk.txt').sample.strip until (word.length >= 5) && (word.length <= 12)
    @word
  end

  def guess!(char)
    @guesses.append(char)
  end

  def guess_correct?(char)
    @word.include?(char)
  end

  def incorrect_guess!
    @lives -= 1
  end

  def find_correct_indices
    correct_indices = []
    @word.each_char.with_index do |char_word, index|
      @guesses.each do |char_guess|
        correct_indices.append(index) if char_word.downcase == char_guess.downcase
      end
    end
    correct_indices.uniq
  end
  
  def won?
    find_correct_indices.length == @word.length
  end

  def print_word
    correct_indices = find_correct_indices
    word.each_char.with_index do |char, index|
      if correct_indices.include?(index)
        print char
      else
        print '_'
      end
    end
    puts
  end
end
choice = 'TBD'
until ['n', 'l', ''].include?(choice.downcase)
  puts 'Play a [n]ew game or [l]oad the save? (Nl)'
  choice = gets.chomp
end
choice = choice.downcase
case choice
when 'n', ''
  game = Game.new
  game.pick_random_word
when 'l'
  game = Game.new # TODO: load file.
end
puts game.word # TODO: delete, useful only for testing.
lives_counter = 'HANGMAN'
saved_game = false
until game.lives.zero?
  puts "Guesses so far: #{game.guesses}"
  print 'Word so far: '
  game.print_word
  puts "Lives left so far: #{lives_counter[0..(7 - game.lives)]}"
  puts 'Make a guess! (Or press enter and save the game.)'
  guess = gets.chomp[0]
  if guess.nil?
    saved_game = true
    # TODO: save game.
    break
  end
  guess = guess.downcase
  if game.guesses.include?(guess)
    puts 'You already tried that!'
    next
  end
  game.guess!(guess)
  game.incorrect_guess! unless game.guess_correct?(guess)
  system "clear"; system "cls"
  if game.won?
    game.print_word
    puts 'You win!'
    break
  end
end
unless game.won? or saved_game
  puts 'You ran out of guesses.'
  print 'The word was: '
  game.print_word
end

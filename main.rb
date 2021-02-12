class Game
  attr_reader :lives
  def self.pick_random_word
    word = ''
    until word.length >= 5 and word.length <= 12
      word = File.readlines('5desk.txt').sample.strip
    end
  end
end
p Game.pick_random_word

require 'Matrix'
class Solver

  def initialize(puzzle_text)
    @puzzle_text = puzzle_text
    @puzzle_values = Array.new
  end

  def parse
    lines = @puzzle_text.split("\n")
    @puzzle_values = lines.map do |line|
      each_line = line.split("").fill(" ", line.length..8)
      each_line.map { |value| value.to_i }
    end
    p @puzzle_values
  end

end

tester = Solver.new("   26 7 1
68  7  9
19   45
82 1   4
  46 29
 5   3 28
  93   74
 4  5  36
7 3 18  ")
tester.parse

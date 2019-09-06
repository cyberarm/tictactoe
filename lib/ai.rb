class Ai
  attr_reader :player
  def initialize(grid:, player:)
    @grid = grid
    @player = player

    generate_name

    setup if defined?(setup)
  end

  def generate_name
    list = []
    4.times do
      list << rand(65..65+25)
    end
    @name = "Ai-#{list.pack("c*")}"
  end

  def name
    @name
  end

  def your_turn
    solve
  end

  def solve
    raise NotImplementedError, "No solver for #{self.class} was implemented!"
  end
end
class Ai
  attr_reader :player
  def initialize(grid: $window.grid, player:)
    @grid = grid
    @player = player

    generate_name
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
    my_grid = []
    @grid.grid.each_with_index do |list, y|
      list.each_with_index do |point, x|
        next if point
        throw(:nope) if point != false
        my_grid << Point.new(x, y)
      end
    end

    if my_grid.size > 0
      decision = my_grid[SecureRandom.random_number(0..my_grid.size-1)]

      cell = @grid.cells.detect {|cell| if cell.point.x == decision.x && cell.point.y == decision.y; true; end}

      cell.reserved = true
      $window.grid.notify(cell)
    end
  end
end
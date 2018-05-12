class Ai
  attr_reader :player
  def initialize(grid: $window.grid, player:)
    @grid = grid
    @player = player
  end

  def your_turn
    solve
  end

  def solve
    my_grid = []
    @grid.grid.each_with_index do |list, y|
      list.each_with_index do |point, x|
        next if point
        my_grid << Point.new(x, y)
      end
    end

    if my_grid.size > 0
      decision = my_grid[rand(0..my_grid.size-1)]

      p decision

      cell = @grid.cells.detect {|cell| if cell.point.x == decision.x && cell.point.y == decision.y; true; end}

      puts "cell"
      cell.reserved = true
      $window.grid.notify(cell)
    end
  end
end
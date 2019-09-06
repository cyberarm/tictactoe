class RandomAi < Ai
  def solve
    my_grid = @grid.cells.select { |cell| !cell.reserved }

    if my_grid.size > 0
      cell = my_grid[SecureRandom.random_number(0..my_grid.size-1)]

      @grid.notify(cell)
    end
  end
end
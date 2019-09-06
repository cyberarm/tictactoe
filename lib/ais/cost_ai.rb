class CostAi < Ai
  def me_at?(point)
    @grid.cell_at(point).player == @player
  end

  def empty_at?(point)
    !@grid.cell_at(point).reserved
  end

  def solve
    risks = @grid.win_scenarios.map do |scenario|
      risk = 0
      options = []

      scenario.each do |point|
        if me_at?(point) || empty_at?(point)
          options << point unless me_at?(point)
        else
          risk+=1
        end
      end

      {scenario: scenario, risk: risk / scenario.size.to_f, options: options}
    end

    risks.sort! { |b, a| a[:risk] <=> b[:risk] }.delete_if { |assessment| assessment[:risk] <= 0.01 }

    assessment = risks.detect { |r| r[:options].size > 0 }

    found = nil
    @grid.cells.select { |cell| !cell.reserved }.each do |cell|
      found = assessment[:options].detect do |option|
        cell if !cell.reserved && cell.point.x == option.x && cell.point.y == option.y
      end


      if found
        @grid.notify(cell)
        break
      end
    end

    throw(:nope) unless found
  end
end
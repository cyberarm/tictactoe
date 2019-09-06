class Grid
  attr_reader :cells, :win_scenarios
  def initialize(window:, grid_size: 3, cell_size: 64)
    @window = window
    @grid_size = grid_size
    @cell_size = cell_size

    @font = Gosu::Font.new(24)
    @title= "Tic-Tac-Toe"

    raise "Grid grid_size must be divisible by 3" unless (@grid_size.to_f / 3) % 1 <= 0.0001

    @win_scenarios = []
    build_win_scenarios

    @cells = []
    build_cells

    @players = [:X, :O]
    @player_index = 0
    @game_over = false
    @turn = @players[@player_index]

    @human = @players[@player_index]
    unless ARGV.join.include?("--1v1")
      @ai = CostAi.new(grid: self, player: @players[@player_index+1])
    end
  end

  def build_win_scenarios
    # ROWS
    @grid_size.times do |y|
      scenario = []
      @grid_size.times do |x|
        scenario << point(x, y)
      end

      @win_scenarios << scenario.freeze
    end

    # COLUMNS
    @grid_size.times do |x|
      scenario = []
      @grid_size.times do |y|
        scenario << point(x, y)
      end

      @win_scenarios << scenario.freeze
    end

    # DIAGONALS
    x1 = 0
    y1 = 0
    x2 = 0
    y2 = @grid_size - 1
    _one = []
    _two = []

    @grid_size.times do |i|
      _one << point(x1 + i, y1 + i)
      _two << point(x2 + i, y2 - i)
    end

    @win_scenarios.push(_one.freeze, _two.freeze)
    @win_scenarios.freeze
  end

  def build_cells
    # Top Row
    size = @cell_size * 2

    @grid_size.times do |y|
      @grid_size.times do |x|
        @cells << Cell.new((size - @cell_size) + x * size, (size - @cell_size) + y * size, size - 2, size - 2, point(x, y))
      end
    end
  end

  def point(x, y)
    return Point.new(x,y)
  end

  def cell_at(point)
    @cells.dig(@grid_size * point.y + point.x)
  end

  def draw
    #Title
    @font.draw_text(@title, @window.width/2-@font.text_width(@title)/2, @cell_size/2-@font.height/2, 10)
    @font.draw_text("Turn: #{@turn.to_s}", 10, 10, 10)

    draw_backing

    @cells.each(&:draw)
  end

  def draw_backing
    size = @cell_size * 2

    Gosu.draw_rect(@cell_size, @cell_size, size * @grid_size - 2, size * @grid_size - 2, Gosu::Color.rgb(50,75,100))

    (@grid_size - 1).times do |i|
      Gosu.draw_rect(@cell_size, ((size - @cell_size) + i * size - 2) + size, size * @grid_size - 2, 2, Gosu::Color::BLACK)
      Gosu.draw_rect(((size - @cell_size) + i * size - 2) + size, @cell_size, 2, size * @grid_size - 2, Gosu::Color::BLACK)

    end
  end

  def update
    reserved = 0
    @cells.each do |cell|
      cell.update

      if cell.reserved
        reserved+=1
      end
    end

    if reserved == @cells.count && !@game_over
      @title = "Draw"
    end


    catch(:win_found) do
      check_win_scenarios unless @game_over
    end

    if @ai && @turn == @ai.player && @cells.count != reserved && !@game_over
      @ai.your_turn
    end
  end

  def check_win_scenarios
    @players.each do |player|
      @win_scenarios.each_with_index do |scenario, scenario_index|
        matches = 0
        scenario.each do |point|
          if cell_at(point).player == player
            matches+=1
          end
        end

        if matches == scenario.size
          puts "matches: #{matches}- Win? #{ matches == scenario.size} - Scenerio: #{scenario_index}"
          puts "WIN"
          if @ai
            @title = "#{Etc.getlogin} Won!" if player == @human
            @title = "#{@ai.name} Won!" if player != @human
          else
            @title = "#{player} Won!"
          end
          @game_over = true
          @cells.each {|cell| cell.reserved = true}
          throw(:win_found)
        end
      end
    end
  end

  def notify(cell)
    unless cell_at(cell.point).reserved
      cell.reserved = true
      cell.player = @turn
      @player_index +=1 if @player_index < @players.count
      @player_index = 0 if @player_index >= @players.count
      @turn = @players[@player_index]
    end
  end

  def button_up(id)
    if @turn == @human || !@ai
      @cells.each {|c| c.button_up(id)}
    end
  end
end
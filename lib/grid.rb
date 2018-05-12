class Grid
  attr_reader :grid, :cells
  def initialize(window:)
    @window = window
    @font = Gosu::Font.new(24)
    @title= "Tic-Tac-Toe"
    @x_padding = (@window.width/4)/2
    @y_padding = (@window.height/4)/2

    @grid = [
              [false, false, false],
              [false, false, false],
              [false, false, false]
            ]
    @win_scenarios =[
                      # ROWS
                      [point(0,0), point(1,0), point(2,0)],
                      [point(0,1), point(1,1), point(2,1)],
                      [point(0,2), point(1,2), point(2,2)],

                      # COLUMNS
                      [point(0,0), point(0,1), point(0,2)],
                      [point(1,0), point(1,1), point(1,2)],
                      [point(2,0), point(2,1), point(2,2)],

                      # DIAGONALS
                      [point(0,0), point(1,1), point(2,2)],
                      [point(0,2), point(1,1), point(2,0)]
                    ]
    @cells = []
    build_cells

    @players = [:X, :O]
    @player_index = 0
    @game_over = false
    @turn = @players[@player_index]

    @human = @players[@player_index]
    @ai = Ai.new(grid: self, player: @players[@player_index+1])
  end

  def build_cells
    # Top Row
    @cells << Cell.new(@x_padding, @y_padding, (@x_padding*2), (@y_padding*2), point(0,0))
    @cells << Cell.new(2+@x_padding*3.0, @y_padding, (@x_padding*2)-2, (@y_padding*2), point(1,0))
    @cells << Cell.new(2+@x_padding*5.0, @y_padding, (@x_padding*2)-2, (@y_padding*2), point(2,0))

    # Middle Row
    @cells << Cell.new(@x_padding, 2+@y_padding*3.0, (@x_padding*2), (@y_padding*2)-2, point(0,1))
    @cells << Cell.new(2+@x_padding*3.0, 2+@y_padding*3.0, (@x_padding*2)-2, (@y_padding*2)-2, point(1,1))
    @cells << Cell.new(2+@x_padding*5.0, 2+@y_padding*3.0, (@x_padding*2)-2, (@y_padding*2)-2, point(2,1))

    # Bottom Row
    @cells << Cell.new(@x_padding, 2+@y_padding*5.0, (@x_padding*2), (@y_padding*2)-2, point(0,2))
    @cells << Cell.new(2+@x_padding*3.0, 2+@y_padding*5.0, (@x_padding*2)-2, (@y_padding*2)-2, point(1,2))
    @cells << Cell.new(2+@x_padding*5.0, 2+@y_padding*5.0, (@x_padding*2)-2, (@y_padding*2)-2, point(2,2))
  end

  def point(x, y)
    return Point.new(x,y)
  end

  def draw
    #Title
    @font.draw(@title, @window.width/2-@font.text_width(@title)/2, @y_padding/2-@font.height/2, 10)
    @font.draw("Turn: #{@turn.to_s}", 10, 10, 10)
    # BACKGROUND
    Gosu.draw_rect(@x_padding, @y_padding, @window.width-(@x_padding*2), @window.height-(@y_padding*2), Gosu::Color.rgb(50,75,100))
    # LINES
    #   ROWS
    Gosu.draw_rect(@x_padding, @y_padding*3.0, @window.width-(@x_padding*2), 2, Gosu::Color::BLACK)
    Gosu.draw_rect(@x_padding, @y_padding*5.0, @window.width-(@x_padding*2), 2, Gosu::Color::BLACK)
    #   COLS
    Gosu.draw_rect(@x_padding*3.0, @y_padding, 2, @window.height-(@y_padding*2), Gosu::Color::BLACK)
    Gosu.draw_rect(@x_padding*5.0, @y_padding, 2, @window.height-(@y_padding*2), Gosu::Color::BLACK)

    @cells.each(&:draw)
  end

  def update
    reserved = 0
    @cells.each do |cell|
      cell.update

      if cell.reserved
        reserved+=1
      end
    end

    if @cells.count == reserved && !@game_over
      @title = "Draw"
    end

    if @turn == @ai.player && @cells.count != reserved && !@game_over
      @ai.your_turn
    end

    catch(:win_found) do
      check_win_scenarios unless @game_over
    end
  end

  def check_win_scenarios
    @players.each do |player|
      @win_scenarios.each_with_index do |scenario, scenario_index|
        matches = 0
        scenario.each do |point|
          if @grid[point.x][point.y] == player
            matches+=1
          end
        end

        if matches == scenario.size
          puts "matches: #{matches}- Win? #{ matches == scenario.size} - Scenerio: #{scenario_index}"
          puts "WIN"
          @title = "#{player} Won!"
          @game_over = true
          @cells.each {|cell| cell.reserved = true}
          throw(:win_found)
        end
      end
    end
  end

  def notify(cell)
    unless @grid[cell.point.x][cell.point.y]
      @grid[cell.point.x][cell.point.y] = @turn
      cell.player = @turn
      @player_index +=1 if @player_index < @players.count
      @player_index = 0 if @player_index >= @players.count
      @turn = @players[@player_index]
    end
  end

  def button_up(id)
    if @turn == @human
      @cells.each {|c| c.button_up(id)}
    end
  end
end
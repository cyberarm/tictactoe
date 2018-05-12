class Grid
  Point = Struct.new(:x, :y)
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
                      [[0,0], [1,0], [2,0]],
                      [[0,1], [1,1], [2,1]],
                      [[0,2], [1,2], [2,2]],

                      [[0,0], [0,1], [0,1]],
                      [[1,0], [1,1], [1,2]],
                      [[2,0], [2,1], [2,2]],

                      [[0,0], [1,1], [2,2]],
                      [[0,2], [1,1], [2,0]],
                    ]
    @cells = []
    build_cells

    @players = [:x, :o]
    @player_index = 0
    @turn = @players[@player_index]
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
    @font.draw(@turn.to_s, 10, 10, 10)
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

    if @cells.count == reserved
      @title = "Game Over"
    end
  end

  def notify(cell)
    @grid[cell.point.x][cell.point.y] = @turn
    cell.player = @turn
    @player_index +=1 if @player_index < @players.count
    @player_index = 0 if @player_index >= @players.count
    @turn = @players[@player_index]
  end

  def button_up(id)
    @cells.each {|c| c.button_up(id)}
  end
end
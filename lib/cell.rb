class Cell
  attr_reader :x, :y, :width, :height, :point, :player, :reserved
  def initialize(x, y, width, height, point)
    @x, @y, @width, @height , @point = x, y, width, height, point
    @reserved = false
    @player = ""

    @cell_font = Gosu::Font.new(height-10, name: "Consolas")

    @color          = Gosu::Color.rgb(90, 15, 45)
    @hover_color    = Gosu::Color.rgb(90 + 10, 15 + 10, 45 + 10)
    @active_color   = Gosu::Color.rgb(90 - 10, 15 - 10, 45 - 10)
    @reserved_color = Gosu::Color.rgb(90 - 20, 15 - 20, 45 - 20)
  end

  def draw
    if @reserved
      Gosu.draw_rect(@x, @y, @width, @height, @reserved_color)
      @cell_font.draw_text(@player, @x + (@width / 2) - (@cell_font.text_width(@player) / 2), y, 10)
    elsif mouse_over? && Gosu.button_down?(Gosu::MsLeft)
      Gosu.draw_rect(@x, @y, @width, @height, @active_color)
    elsif mouse_over?
      Gosu.draw_rect(@x, @y, @width, @height, @hover_color)
    else
      Gosu.draw_rect(@x, @y, @width, @height, @color)
    end
  end

  def update
  end

  def player=(symbol)
    @player = symbol
  end

  def reserved=(boolean)
    @reserved = boolean
  end

  def mouse_over?
    $window.mouse_x.between?(@x, @x + @width) &&
    $window.mouse_y.between?(@y, @y + @height)
  end

  def button_up(id)
    if id == Gosu::MsLeft
      if mouse_over? && !@reserved
        $window.grid.notify(self)
      end
    end
  end
end
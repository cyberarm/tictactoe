class Display < Gosu::Window
  attr_reader :grid
  def initialize(*args)
    super(*args)
    self.caption = "Tic-Tac-Toe"
    @grid = Grid.new(window: self)
    $window = self
  end

  def draw
    draw_rect(0,0, self.width, self.height, Gosu::Color.rgba(120,100,120,200))
    @grid.draw
  end

  def update
    @grid.update
  end

  def needs_cursor?; true; end

  def button_up(id)
    close if id == Gosu::KbEscape
    @grid = Grid.new(window: self) if id == Gosu::KbF5
    @grid.button_up(id)
  end
end
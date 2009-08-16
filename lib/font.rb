class Font < Gosu::Font
  include Opacity

  def initialize(window, font, size, color = Gosu::Color.new(0xffffffff))
    super(window, font, size)
    @colors = { :font => color }
  end

  def draw(text, x, y, zorder, x_factor, y_factor)
    super(text, x, y, zorder, x_factor, y_factor, @colors[:font])
  end
end

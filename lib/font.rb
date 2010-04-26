class Font < Gosu::Font
  include Opacity

  required_arguments :window, :height
  default_arguments {{color: lambda{ Gosu::Color.new(0xffffffff) }, font: Gosu.default_font_name}}
  def initialize(args = { })
    super(args[:window], args[:font], args[:height])
    @colors = { :font => args[:color].call }
  end


  required_arguments :text, :x, :y
  default_arguments {{zorder: 1, x_factor: 1.0, y_factor: 1.0}}
  def draw(args = { })
    super(args[:text], args[:x], args[:y], args[:zorder], args[:x_factor], args[:y_factor], @colors[:font])
  end
end

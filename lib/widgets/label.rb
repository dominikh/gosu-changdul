module Widgets
  class Label < Widget
    def initialize(window, text, x, y)
      super(window, x, y, 0, 0, :font_height => 60)
      @width, @height = @font.text_width(text), @font.height
      @text = text
      @selectable = false
    end

    def draw
      @text.split("\n").each_with_index do |line, index|
        @font.draw line, @x, @y + index*@font.height, @zorder, 1.0, 1.0
      end
    end
  end
end

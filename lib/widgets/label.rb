module Widgets
  class Label < Widget
    required_arguments :window, :text, :x, :y
    default_arguments width: 0, height: 0
    def initialize(args = { })
      super(args, :font_height => 60)
      @text = args[:text]
      @width, @height = @font.text_width(@text), @font.height
      @selectable = false
    end

    def draw
      @text.split("\n").each_with_index do |line, index|
        @font.draw text: line, x: @x, y: @y + index*@font.height
      end
    end
  end
end

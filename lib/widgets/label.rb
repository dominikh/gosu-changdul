module Widgets
  class Label < Widget
    required_arguments :window, :text, :x, :y
    default_arguments {{width: 0, height: 0}}
    def initialize(args = { })
      super(args, :font_height => 60)
      self.text = args[:text]
      @height = @font.height
      @selectable = false
    end

    def text=(val)
      @text = val
      @width = @font.text_width(val)
    end

    def draw
      @text.split("\n").each_with_index do |line, index|
        @font.draw text: line, x: real_x, y: real_y + index*@font.height, zorder: @parent.zorder
      end
    end
  end
end

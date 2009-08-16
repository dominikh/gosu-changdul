module Widgets
  class FPS < Label
    def initialize(window, fps, x, y)
      @fps = fps
      super(window, @fps.to_i.to_s, x, y)
      @font = Font.new(@window, Gosu.default_font_name, 32)
    end

    def update
      @text = @fps.to_i.to_s
      @width, @height = @font.text_width(@text), @font.height
      super
    end
  end
end

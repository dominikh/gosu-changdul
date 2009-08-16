module Widgets
  class FPS < Label
    required_arguments :window, :fps, :x, :y
    def initialize(args = { })
      @fps = args[:fps]
      super(window: args[:window], text: @fps.to_i.to_s, x: args[:x], y: args[:y])
      @font = Font.new(window: @window, height: 32)
    end

    def update
      @text = @fps.to_i.to_s
      @width, @height = @font.text_width(@text), @font.height
      super
    end
  end
end

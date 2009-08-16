module Widgets
  class Button < Widget
    attr_accessor :text
    def initialize(window, text, x, y)
      super(window, x, y, 0, 0)
      @width, @height = @font.text_width(text)+10, @font.height+10
      @text = text
      @colors = {
        :normal => Gosu::Color.new(0xff00aaff),
        :hover  => Gosu::Color.new(0xff0000ff),
        :clicked => Gosu::Color.new(0xffff0000),
      }
    end

    # TODO add check if parent is set

    def draw
      color = @colors[if under_point?(@window.mouse_x, @window.mouse_y) and @window.button_down?(Gosu::Button::MsLeft) and @parent.active? and focussed?
                        :clicked
                      elsif under_point?(@window.mouse_x, @window.mouse_y) and @parent.active?
                        :hover
                      else
                        :normal
                      end
                     ]

      @window.draw_quad(@x, @y, color,
                        @x+@width, @y, color,
                        @x+@width, @y+@height, color,
                        @x, @y+@height, color, @zorder
                        )
      @font.draw(@text, @x+5, @y+5, @zorder, 1.0, 1.0)
    end
  end
end

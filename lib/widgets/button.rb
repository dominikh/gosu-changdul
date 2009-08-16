module Widgets
  class Button < Widget
    attr_accessor :text
    required_arguments :window, :label, :x, :y
    default_arguments width: 0, height: 0, x: 0, y: 0
    def initialize(args = { })
      super
      @label = args[:label]
      @width, @height = @font.text_width(@label)+10, @font.height+10
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

      @parent.draw_quad(x1: @x, y1: @y,
                        x2: @x+@width, y2: @y,
                        x3: @x+@width, y3: @y+@height,
                        x4: @x, y4: @y+@height,
                        zorder: @zorder, color: color
                        )

      @font.draw(text: @label, x: real_x+5, y: real_y+5, zorder: @zorder)
    end
  end
end

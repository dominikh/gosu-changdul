module Widgets
  class Button < Container
    required_arguments :window, :label, :x, :y
    default_arguments width: 0, height: 0, x: 0, y: 0
    def initialize(args = { })
      super
      @label = Label.new(window: @window, text: args[:label], x: 5, y: 5)
      @width, @height = @label.width+10, @label.height+10
      self.add @label

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

      super
    end
  end
end

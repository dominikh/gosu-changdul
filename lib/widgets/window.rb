module Widgets
  class Window < Container
    include Draggable

    attr_accessor :title
    default_arguments title: "<nil>"
    def initialize(args = { })
      super
      @title = args[:title]

      b = Widgets::Button.new(window: @window, label: "Decrease opacity", x: 50, y: 50)
      b.signal_connect(:click) do
        self.opacity -= 0.1
      end
      add(b)

      b = Widgets::Button.new(window: @window, label: "Increase opacity", x: 50, y: 80)
      b.signal_connect(:click) do
        self.opacity += 0.1
      end
      add(b)

      @colors = { }
      color = Gosu::Color.new(0xff000000)
      color.red = rand(255 - 40) + 40
      color.green = rand(255 - 40) + 40
      color.blue = rand(255 - 40) + 40

      @colors[:body] = color
      @colors[:titlebar] = {
        :active => Gosu::Color.new(0xff00bbff),
        :inactive => Gosu::Color.new(0xff444444),
      }
    end

    def zorder=(val)
      super
      @widgets.each do |widget|
        widget.zorder = val
      end
    end

    def titlebar_points
      Gosu::Rect.new(@x, @y, @width, @font.height+5)
    end

    def drawable_area
      # FIXME should ignore the titlebar again, without screwing up relative positions
      rect
    end

    def drag_init_area
      titlebar_points
    end

    def draw
      @window.draw_quad(@x, @y, @colors[:body],
                        @x+@width, @y, @colors[:body],
                        @x+@width, @y+@height, @colors[:body],
                        @x, @y+@height, @colors[:body], @zorder)

      x1, y1 = titlebar_points.topleft
      x2, y2 = titlebar_points.topright
      x3, y3 = titlebar_points.bottomright
      x4, y4 = titlebar_points.bottomleft
      tcolor = active? ? :active : :inactive

      @window.draw_quad(x1, y1, @colors[:titlebar][tcolor],
                        x2, y2, @colors[:titlebar][tcolor],
                        x3, y3, @colors[:titlebar][tcolor],
                        x4, y4, @colors[:titlebar][tcolor], @zorder)

      @font.draw(text: @title, x: x+5, y: y+5, zorder: @zorder)

      super
    end

    def button_down(id)
      dont_super = false
      if @window.button_down?(Gosu::Button::KbLeftAlt)
        case id
        when Gosu::Button::MsWheelDown
          self.opacity -= 0.05
        when Gosu::Button::MsWheelUp
          self.opacity += 0.05
        when Gosu::Button::MsLeft
          self.start_dragging
          dont_super = true
        end
      end
      super unless dont_super
    end
  end
end

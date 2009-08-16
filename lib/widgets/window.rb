module Widgets
  class Window < Container
    include Draggable

    attr_accessor :title
    def initialize(window, x, y, width, height, args = { })
      super(window, x, y, width, height)
      @title = args[:title] || "<nil>"

      b = Widgets::Button.new(@window, "Decrease opacity", 0, 0)
      b.signal_connect(:click) do
        self.opacity -= 0.1
      end
      add(b, 50, 50)

      b = Widgets::Button.new(@window, "Increase opacity", 0, 0)
      b.signal_connect(:click) do
        self.opacity += 0.1
      end
      add(b, 50, 80)

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
        widget.zorder = widget.initial_zorder + val
      end
    end

    def titlebar_points
      [
       [@x, @y],
       [@x+@width, @y],
       [@x+@width, @y+@font.height+5],
       [@x, @y+@font.height+5],
      ]
    end

    def drawable_area
      [
       [@x, @y+@font.height+5],
       [@x+@width, @y+@font.height+5],
       [@x+@width, @y+@height],
       [@x, @y+@height],
      ]
    end

    def drag_init_area
      titlebar_points
    end

    def draw
      @window.draw_quad(@x, @y, @colors[:body],
                        @x+@width, @y, @colors[:body],
                        @x+@width, @y+@height, @colors[:body],
                        @x, @y+@height, @colors[:body], @zorder)

      x1, y1, x2, y2, x3, y3, x4, y4 = *(titlebar_points.flatten)
      tcolor = active? ? :active : :inactive

      @window.draw_quad(x1, y1, @colors[:titlebar][tcolor],
                        x2, y2, @colors[:titlebar][tcolor],
                        x3, y3, @colors[:titlebar][tcolor],
                        x4, y4, @colors[:titlebar][tcolor], @zorder)

      @font.draw(@title, x+5, y+5, @zorder, 1.0, 1.0)

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

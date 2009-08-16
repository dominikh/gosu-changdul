module Widgets
  module Draggable
    def drag_init_area
      [
       [@x, @y],
       [@x+@width, @y],
       [@x+@width, @y+@height],
       [@x, @y+@height],
      ]
    end

    def in_drag_init_area?
      # left up, right bottom
      points = drag_init_area
      Gosu.point_in_box?(*points[0], *points[2], @window.mouse_x, @window.mouse_y)
    end

    def dragging?
      @dragging
    end

    def start_dragging
      @dragging = [@window.mouse_x - @x, @window.mouse_y - @y]
    end

    def stop_dragging
      @dragging = nil
    end

    def update
      drag_to(@window.mouse_x, @window.mouse_y) if dragging?
      super
    end

    def drag_to(x, y)
      p_corners = @parent.drawable_area
      w_corners = self.corners

      x_allowed = p_corners[0][0]..p_corners[1][0]
      y_allowed = p_corners[0][1]..p_corners[3][1]

      dx = x - @dragging[0]
      dy = y - @dragging[1]

      # dont move too far left
      if dx < x_allowed.min
        dx = x_allowed.min
        @window.mouse_x = x_allowed.min + @dragging[0]
      end

      # dont move too far right
      if dx + w_corners[1][0] - w_corners[0][0]> x_allowed.max
        dx = x_allowed.max - width
        @window.mouse_x = x_allowed.max - width + @dragging[0]
      end

      # dont move too far up
      if dy < y_allowed.min
        dy = y_allowed.min
        @window.mouse_y = y_allowed.min + @dragging[1]
      end

      # dont move too far down
      if dy + w_corners[3][1] - w_corners[0][1] > y_allowed.max
        dy = y_allowed.max - height
        @window.mouse_y = y_allowed.max - height + @dragging[1]
      end

      self.x = dx
      self.y = dy
    end

    def button_down(id)
      if id == Gosu::Button::MsLeft and in_drag_init_area?
        start_dragging
      end
      super
    end

    def button_up(id)
      super
      if id == Gosu::Button::MsLeft and dragging?
        stop_dragging
      end
    end
  end
end

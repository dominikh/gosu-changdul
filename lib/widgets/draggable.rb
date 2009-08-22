module Widgets
  module Draggable
    def drag_init_area
      rect
    end

    def in_drag_init_area?
      drag_init_area.collide_point? @window.mouse_x, @window.mouse_y
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
      w_corners = self.rect

      x_allowed = p_corners.left..p_corners.right
      y_allowed = p_corners.top..p_corners.bottom

      dx = x - @dragging[0]
      dy = y - @dragging[1]

      # dont move too far left
      if dx < x_allowed.min
        dx = x_allowed.min
        @window.mouse_x = x_allowed.min + @dragging[0]
      end

      # dont move too far right
      if dx + w_corners.right - w_corners.left> x_allowed.max
        dx = x_allowed.max - width
        @window.mouse_x = x_allowed.max - width + @dragging[0]
      end

      # dont move too far up
      if dy < y_allowed.min
        dy = y_allowed.min
        @window.mouse_y = y_allowed.min + @dragging[1]
      end

      # dont move too far down
      if dy + w_corners.bottom - w_corners.top > y_allowed.max
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

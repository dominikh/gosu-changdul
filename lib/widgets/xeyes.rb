module Widgets
  class XEyes < Container
    class Eye < Widget
      SOCKET_RADIUS = 15
      PUPIL_RADIUS  = 5
      default_arguments width: 200, height: 200
      def initialize(args = { })
        super
      end

      def pupil_pos
        csrX = @window.mouse_x
        csrY = @window.mouse_y

        e1x = real_x + SOCKET_RADIUS
        e1y = real_y + SOCKET_RADIUS

        dx   = csrX - e1x
        dy   = csrY - e1y

        r    = SOCKET_RADIUS-PUPIL_RADIUS
        _r   = Math.sqrt(dx**2 + dy**2)

        x    = (r/_r) * dx
        y    = (r/_r) * dy

        x = (_r < r) ? dx : dx*(r/_r);
        y = (_r < r) ? dy : dy*(r/_r);
        [x+@x+PUPIL_RADIUS*2, y+@y+PUPIL_RADIUS*2]
      end

      def draw
        x, y = pupil_pos
        @parent.draw_circle(x: @x+SOCKET_RADIUS, y: @y+SOCKET_RADIUS, radius: SOCKET_RADIUS, stroke: SOCKET_RADIUS, segments: 15) # the socket
        @parent.draw_circle(x: x+PUPIL_RADIUS, y: y+PUPIL_RADIUS, radius: PUPIL_RADIUS, stroke: PUPIL_RADIUS, color: Gosu::Color.new(0xff000000), segments: 10) # the pupil
      end
    end

    required_arguments :x, :y
    def initialize(args = { })
      args[:width]  = 400
      args[:height] = 400
      super(args)

      add Eye.new(window: args[:window], x: 20, y: 20)
      add Eye.new(window: args[:window], x: 55, y: 20)
    end
  end
end

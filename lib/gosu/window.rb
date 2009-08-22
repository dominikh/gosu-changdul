module Gosu
  class Window
    def draw_circle(x, y, r1, r2, color, zorder = 1)
      radius = r1
      stroke = r2

      segments = 45
      a_segments = 360 / segments

      outer = []
      inner = []

      segments.times do |seg|
        angle = a_segments * seg
        o_x = Gosu::offset_x(angle, radius)
        o_y = Gosu::offset_y(angle, radius)
        outer << [o_x + x, o_y + y]
        i_x = Gosu::offset_x(angle, radius - stroke)
        i_y = Gosu::offset_y(angle, radius - stroke)
        inner << [i_x + x, i_y + y]
      end

      segments.times do |seg|
        self.draw_quad(outer[seg][0], outer[seg][1], color,
                       outer[seg - 1][0], outer[seg - 1][1], color,
                       inner[seg][0], inner[seg][1], color,
                       inner[seg - 1][0], inner[seg - 1][1], color, zorder)
      end
    end
  end
end

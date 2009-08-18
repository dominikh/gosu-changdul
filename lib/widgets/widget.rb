module Widgets
  class Widget
    include Opacity

    attr_accessor :x
    attr_accessor :y
    attr_accessor :width
    attr_accessor :height
    attr_accessor :zorder
    attr_writer :active
    attr_accessor :focussed
    attr_accessor :parent
    attr_accessor :selectable

    required_arguments :window, :x, :y, :width, :height
    default_arguments zorder: 1, font_height: 16
    def initialize(args = { })
      @window = args[:window]
      @x, @y, @width, @height = args[:x], args[:y], args[:width], args[:height]
      @selected = false
      @zorder = args[:zorder]
      @active = false
      @focussed = false
      @signals = { :button_down => nil, :button_up => nil}
      @parent  = FakeParent.new(0,0, @window.width, @window.height)
      @font = Font.new(window: @window, height: args[:font_height])
      @colors = { }

      @selectable = true
    end

    def real_x
      @x + @parent.real_x
    end

    def real_y
      @y + @parent.real_y
    end

    def corners
      [
       [@x, @y],
       [@x+@width, @y],
       [@x+@width, @y+@height],
       [@x, @y+@height],
      ]
    end

    def real_corners
      [
       [real_x, real_y],
       [real_x+@width, real_y],
       [real_x+@width, real_y+@height],
       [real_x, real_y+@height],
      ]
    end

    def drawable_area
      corners
    end

    def real_drawable_area
      real_corners
    end

    def opacity=(val)
      super
      @font.opacity = val
    end

    def active?
      @active
    end

    def selectable?
      @selectable
    end

    def focussed?
      @focussed
    end

    def focus
      @focussed = true
    end

    def unfocus
      @focussed = false
    end

    def under_point?(xd, yd)
      Gosu.point_in_box?(real_x, real_y, real_x+@width, real_y+@height, xd, yd)
    end

    def draw
    end

    def update
      super if defined? super
    end


    def clip_to_drawable_area(&block)
      # FIXME we shouldnt have to work with floats at all here
      area = real_drawable_area
      x, y = area[0]
      w = area[2][0] - x
      h = area[2][1] - y
      @window.clip_to(x.ceil, y.ceil, w.ceil, h.ceil, &block)
    end

    # draw relative to the widget
    # FIXME don't share one color object
    # FIXME actually implement relative zordering
    required_arguments :x1, :y1, :x2, :y22
    default_arguments zorder: 1, mode: :default, color1: Gosu::Color.new(0xffffffff), color2: Gosu::Color.new(0xffffffff), color: nil
    def draw_line(args = { })
      if args[:color]
        args[:color1], args[:color2] = args[:color], args[:color]
      end
      rel_x, rel_y = drawable_area[0]
      clip_to_drawable_area do
        @window.draw_line(args[:x1]+rel_x, args[:y1]+rel_y, args[:color1],
                          args[:x2]+rel_x, args[:y2]+rel_y, args[:color2], @zorder
                          )
      end
    end

    required_arguments :x1, :y1, :x2, :y2, :x3, :y3, :x4, :y4
    default_arguments zorder: 1, mode: :default, color1: Gosu::Color.new(0xffffffff), color2: Gosu::Color.new(0xffffffff), color3: Gosu::Color.new(0xffffffff), color4: Gosu::Color.new(0xffffffff), color: nil
    def draw_quad(args = { })
      if args[:color]
        args[:color1], args[:color2], args[:color3], args[:color4] = args[:color], args[:color], args[:color], args[:color]
      end
      rel_x, rel_y = drawable_area[0]
      clip_to_drawable_area do
        @window.draw_quad(args[:x1]+rel_x, args[:y1]+rel_y, args[:color1],
                          args[:x2]+rel_x, args[:y2]+rel_y, args[:color2],
                          args[:x3]+rel_x, args[:y3]+rel_y, args[:color3],
                          args[:x4]+rel_x, args[:y4]+rel_y, args[:color4], @zorder
                          )
      end
    end

    required_arguments :x1, :y1, :x2, :y2, :x3, :y3
    default_arguments zorder: 1, mode: :default, color1: Gosu::Color.new(0xffffffff), color2: Gosu::Color.new(0xffffffff), color3: Gosu::Color.new(0xffffffff), color: nil
    def draw_triangle(args = { })
      if args[:color]
        args[:color1], args[:color2], args[:color3] = args[:color], args[:color], args[:color]
      end
      clip_to_drawable_area do
        @window.draw_triangle(args[:x1]+rel_x, args[:y1]+rel_y, args[:color1],
                              args[:x2]+rel_x, args[:y2]+rel_y, args[:color2],
                              args[:x3]+rel_x, args[:y3]+rel_y, args[:color3], @zorder
                              )
      end
    end

    def signal_connect(signal, &block)
      unless [:button_down, :button_up, :click].include? signal
        # TODO get real exception classes
        raise "unknown signal"
      end

      @signals[signal] = block
    end

    def button_down(id)
      if id == Gosu::Button::MsLeft
        @active = true
      end
      @signals[:button_down].call if @signals[:button_down]
      super if defined? super
    end

    def button_up(id)
      @signals[:button_up].call if @signals[:button_up]
      if id == Gosu::Button::MsLeft and focussed?
        @signals[:click].call if @signals[:click]
        @active = false
      end
      super if defined? super
    end
  end
end

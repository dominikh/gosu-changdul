module Widgets
  class Widget
    include Opacity

    attr_accessor :x
    attr_accessor :y
    attr_reader :initial_x
    attr_reader :initial_y
    attr_accessor :width
    attr_accessor :height
    attr_reader :initial_zorder
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
      @initial_x, @initial_y = @x, @y
      @selected = false
      @zorder = args[:zorder]
      @initial_zorder = @zorder
      @active = false
      @focussed = false
      @signals = { :button_down => nil, :button_up => nil}
      @parent  = FakeParent.new(0,0, @window.width, @window.height)
      @font = Font.new(window: @window, height: args[:font_height])
      @colors = { }

      @selectable = true
    end

    def corners
      [
       [@x, @y],
       [@x+@width, @y],
       [@x+@width, @y+@height],
       [@x, @y+@height],
      ]
    end

    def drawable_area
      corners
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
      Gosu.point_in_box?(@x, @y, @x+@width, @y+@height, xd, yd)
    end

    def draw
    end

    def update
      super if defined? super
    end

    # draw relative to the widget
    required_arguments :x1, :y1, :x2, :y2, :x3, :y3, :x4, :y4
    default_arguments zorder: 1, mode: :default, color1: Gosu::Color.new(0xffffffff), color2: Gosu::Color.new(0xffffffff), color3: Gosu::Color.new(0xffffffff), color4: Gosu::Color.new(0xffffffff), color: nil
    def draw_quad(args = { })
      # TODO don't draw outside the container
      if args[:color]
        args[:color1], args[:color2], args[:color3], args[:color4] = args[:color], args[:color], args[:color], args[:color]
      end
      rel_x, rel_y = drawable_area[0]

      @window.draw_quad(args[:x1]+rel_x, args[:y1]+rel_y, args[:color1],
                        args[:x2]+rel_x, args[:y2]+rel_y, args[:color2],
                        args[:x3]+rel_x, args[:y3]+rel_y, args[:color3],
                        args[:x4]+rel_x, args[:y4]+rel_y, args[:color4], args[:zorder] + @zorder
                        )
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

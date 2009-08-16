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

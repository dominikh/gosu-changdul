module Widgets
  class Widget
    include Opacity

    attr_reader :x
    attr_reader :y
    attr_reader :width
    attr_reader :height
    attr_accessor :zorder
    attr_writer :active
    attr_accessor :focussed
    attr_reader :parent
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
      @opacity = 1 # TODO this belongs into the Opacity module, and
                   # the draw methods should be changed by that
                   # module, too
    end


    [:x, :y, :width, :height, :parent].each do |attr|
      var = ("@" + attr.to_s).to_sym
      setter = (attr.to_s + "=").to_sym
      define_method(setter) do |val|
        return if instance_variable_get(var) == val
        instance_variable_set(var, val)
        reset_caches
      end
    end

    def reset_caches
      @rect = nil
      @real_rect = nil
      @real_x = nil
      @real_y = nil
    end

    def rect
      @rect ||= Gosu::Rect.new(@x, @y, @width, @height)
    end

    def real_rect
      @real_rect ||= Gosu::Rect.new(real_x, real_y, @width, @height)
    end

    def real_x
      @real_x ||= @x + @parent.real_x
    end

    def real_y
      @real_y ||= @y + @parent.real_y
    end

    def drawable_area
      rect
    end

    def real_drawable_area
      real_rect
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
      real_rect.collide_point? xd, yd
    end

    def draw
    end

    def update
      super if defined? super
    end


    def clip_to_drawable_area(&block)
      # FIXME we shouldnt have to work with floats at all here
      area = real_drawable_area
      x, y = area.topleft
      w, h = area.size
      @window.clip_to(x.ceil, y.ceil, w.ceil, h.ceil, &block)
    end

    # draw relative to the widget
    # TODO DRY the color objects, probably by extending keyword_arguments
    # TODO DRY all of the color handling in this 3 methods
    # FIXME actually implement relative zordering
    required_arguments :x1, :y1, :x2, :y2
    # default_arguments zorder: 1, mode: :default, color1: lambda { Gosu::Color.new(0xffffffff) }, color2: lambda { Gosu::Color.new(0xffffffff) }, color: nil
    default_arguments zorder: 1, mode: :default, colors: [
                                                          Gosu::Color.new(0xffffffff),
                                                          Gosu::Color.new(0xffffffff),
                                                         ], color: nil
    def draw_line(args = { })
      if args[:color]
        colors = [args[:color]] * 2
      else
        colors = args[:colors].map(&:dup)
      end

      colors.each do |color|
        color.opacity = @opacity
      end

      rel_x, rel_y = real_drawable_area.top_left
      clip_to_drawable_area do
        @window.draw_line(args[:x1]+rel_x, args[:y1]+rel_y, colors[0],
                          args[:x2]+rel_x, args[:y2]+rel_y, colors[1], @zorder
                          )
      end
    end

    required_arguments :rect
    default_arguments colors: [
                               Gosu::Color.new(0xffffffff),
                               Gosu::Color.new(0xffffffff),
                               Gosu::Color.new(0xffffffff),
                               Gosu::Color.new(0xffffffff),
    ], zorder: 1, mode: :default, color: nil
    def draw_quad(args = { })
      if args[:color]
        colors = [args[:color]] * 4
      else
        colors = args[:colors].map(&:dup)
      end

      colors.each do |color|
        color.opacity = @opacity
      end


      rel_x, rel_y = real_drawable_area.topleft

      rel_rect = args[:rect].move(rel_x, rel_y)

      x1, y1 = rel_rect.topleft
      x2, y2 = rel_rect.topright
      x3, y3 = rel_rect.bottomright
      x4, y4 = rel_rect.bottomleft

      clip_to_drawable_area do
        @window.draw_quad(x1, y1, colors[0],
                          x2, y2, colors[1],
                          x3, y3, colors[2],
                          x4, y4, colors[3], @zorder
                          )
      end
    end

    required_arguments :x1, :y1, :x2, :y2, :x3, :y3
    default_arguments zorder: 1, mode: :default, colors: [
                                                          Gosu::Color.new(0xffffffff),
                                                          Gosu::Color.new(0xffffffff),
                                                          Gosu::Color.new(0xffffffff)], color: nil
    def draw_triangle(args = { })
      if args[:color]
        colors = [args[:color]] * 3
      else
        colors = args[:colors].map(&:dup)
      end

      colors.each do |color|
        color.opacity = @opacity
      end

      rel_x, rel_y = real_drawable_area.topleft

      clip_to_drawable_area do
        @window.draw_triangle(args[:x1]+rel_x, args[:y1]+rel_y, colors[0],
                              args[:x2]+rel_x, args[:y2]+rel_y, colors[1],
                              args[:x3]+rel_x, args[:y3]+rel_y, colors[2], @zorder
                              )
      end
    end

    required_arguments :x, :y, :radius, :stroke
    default_arguments zorder: 1, color: Gosu::Color.new(0xffffffff), segments: 45
    def draw_circle(args = { })
      args[:color].opacity = @opacity
      rel_x, rel_y = real_drawable_area.topleft

      clip_to_drawable_area do
        @window.draw_circle(args[:x]+rel_x, args[:y]+rel_y, args[:radius], args[:stroke], args[:color], @zorder, args[:segments])
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

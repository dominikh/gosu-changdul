module Widgets
  class Container < Widget
    attr_reader :widgets
    def initialize(window, x, y, width, height)
    def initialize(args = { })
      super
      @widgets = WidgetList.new
    end

    def add(widget, rel_x, rel_y)
      widget.x = @x + rel_x
      widget.y = @y + rel_y
      widget.parent = self
      @widgets << widget
    end

    def x=(val)
      @widgets.each do |widget|
        widget.x -= @x - val
      end
      super
    end

    def y=(val)
      @widgets.each do |widget|
        widget.y -= @y - val
      end
      super
    end

    def opacity=(val)
      super
      @widgets.each do |widget|
        widget.opacity = val
      end
    end

    def button_down(id)
      if id == Gosu::Button::MsLeft
        widget = @widgets.select { |w| w.under_point?(@window.mouse_x, @window.mouse_y)}.sort_by(&:zorder).last
        old_widget = @widgets.find(&:focussed?)
        if old_widget
          old_widget.unfocus
        end

        if widget
          widget.focus
          widget.button_down(id)
        end
      end
      super
    end

    def button_up(id)
      if id == Gosu::Button::MsLeft
        widget = @widgets.select { |w| w.under_point?(@window.mouse_x, @window.mouse_y)}.sort_by(&:zorder).last
        widget.button_up(id) if widget
      end
      super
    end

    def update
      @widgets.each(&:update)
      super
    end

    def draw
      @widgets.each(&:draw)
    end
  end
end

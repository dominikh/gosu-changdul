# encoding: utf-8

require 'rubygems'
require 'gosu'
require 'keyword_arguments'

module Gosu
  #top left and bottom right points
  def self.point_in_box?(x1, y1, x2, y2, xd, yd)
    xd > x1 and xd < x2 and yd > y1 and yd < y2
  end
end

require 'lib/opacity.rb'
require 'lib/widgets/draggable.rb'
require 'lib/widgets/widget.rb'
require 'lib/widgets/button.rb'
require 'lib/widgets/container.rb'
require 'lib/widgets/window.rb'
require 'lib/fake_parent.rb'
require 'lib/cursor.rb'
require 'lib/font.rb'
require 'lib/widget_list.rb'
require 'lib/fps'
require 'lib/widgets/label'
require 'lib/widgets/fps'

class MainWindow < Gosu::Window
  def initialize
    super(1024, 768, false)
    @fps = FPS.new(Gosu.milliseconds)

    @widgets = WidgetList.new
    @widgets << Widgets::Window.new(self, 100, 100, 200, 200, :title => "Window 1")
    @widgets << Widgets::Window.new(self, 150, 150, 200, 200, :title => "Window 2")
    @widgets << Widgets::Window.new(self, 75, 200, 200, 200, :title => "Window 3")
    @widgets << Widgets::Window.new(self, 50, 225, 200, 200, :title => "Window 4")
    @widgets << Widgets::FPS.new(self, @fps, 400, 400)
    @widgets << Widgets::Label.new(self, "Multi\nline¡€®ŦÆ", 400, 600)

    @widgets.set_active(@widgets[-1])
    @cursor  = Cursor.new(self, 'images/cursor.png', true)
  end

  def update_widgets
    unless @updated_widgets
      @widgets.each(&:update)
      @updated_widgets = true
    end
  end

  def button_down(id)
    update_widgets
    widget = @widgets.select { |w| w.under_point?(mouse_x, mouse_y)}.sort_by(&:zorder).last
    if widget
      @widgets.set_active(widget) if id == Gosu::Button::MsLeft
      widget.button_down(id)
    end
  end

  def button_up(id)
    update_widgets
    widget = @widgets.select { |w| w.under_point?(mouse_x, mouse_y)}.sort_by(&:zorder).last
    if widget
      widget.button_up(id)
    end
  end

  def update
    @fps.tick(Gosu.milliseconds)
    update_widgets
    @updated_widgets = false
  end

  def draw
    @cursor.draw
    @widgets.each(&:draw)
  end
end

w = MainWindow.new
w.show

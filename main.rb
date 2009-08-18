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

require 'pp'
require 'lib/opacity.rb'
require 'lib/widgets/draggable.rb'
require 'lib/widgets/widget.rb'
require 'lib/widgets/container.rb'
require 'lib/widgets/button.rb'
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
    @widgets << Widgets::Window.new(window: self, x: 100, y: 100, width: 200, height: 200, :title => "Window 1")
    @widgets << Widgets::Window.new(window: self, x: 150, y: 150, width: 200, height: 200, :title => "Window 2")
    @widgets << Widgets::Window.new(window: self, x: 75,  y: 200, width: 200, height: 200, :title => "Window 3")
    @widgets << Widgets::Window.new(window: self, x: 50,  y: 225, width: 200, height: 200, :title => "Window 4")
    @widgets << Widgets::FPS.new(window: self, fps: @fps, x: 400, y: 400)
    @widgets << Widgets::Label.new(window: self, text: "Multi\nline¡€®ŦÆ", x: 400, y: 600)

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
    update_widgets
    @updated_widgets = false
  end

  def draw
    @fps.tick(Gosu.milliseconds)
    @cursor.draw
    @widgets.each(&:draw)

    @widgets[0].draw_quad(
                           x1: 10, y1: 10,
                           x2: 300, y2: 10,
                           x3: 300, y3: 50,
                           x4: 10, y4: 50,
                           color: Gosu::Color.new(0xffffffff)
                           )
  end
end

w = MainWindow.new
w.show

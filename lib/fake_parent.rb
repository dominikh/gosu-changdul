class FakeParent
  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :height
  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
  end

  def real_x
    @x
  end

  def real_y
    @y
  end

  def rect
    Gosu::Rect.new(@x, @y, @width, @height)
  end

  def real_rect
    rect
  end

  def drawable_area
    rect
  end

  def real_drawable_area
    drawable_area
  end

  def zorder
    1
  end
end

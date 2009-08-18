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

  def zorder
    1
  end
end

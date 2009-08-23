class Float
  alias_method :round_orig, :round
  def round(n=0)
    if n == 0
      self.round_orig
    else
      (self * (10.0 ** n)).round_orig * (10.0 ** (-n))
    end
  end
end

class FPS
  def initialize(init_time, precision=0)
    @precision = precision
    @init_time = init_time
    @ticks = 0
    @fps = 0
  end

  def tick(current_time)
    @ticks += 1
    @fps = (@ticks.to_f / (current_time - @init_time)) * 1000
    if current_time - @init_time >= 1000
      # @fps = @ticks
      @init_time = current_time
      @ticks = 0
    end
  end

  def to_i
    @fps.round(@precision)
  end
end

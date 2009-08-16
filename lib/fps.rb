class FPS
  def initialize(init_time)
    @init_time = init_time
    @ticks = 0
    @fps = 0
  end

  def tick(current_time)
    @ticks += 1
    if current_time - @init_time >= 1000
      @fps = @ticks
      @init_time = current_time
      @ticks = 0
    end
  end

  def to_i
    @fps
  end
end

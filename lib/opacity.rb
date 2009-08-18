module Opacity
  def opacity
    @opacity
  end

  def opacity=(val)
    val = 1 if val > 1
    val = 0 if val < 0
    @opacity = val
    val = (val * 255).floor
    val = 0 if val < 0
    val = 255 if val > 255
    @colors.each do |key, color|
      if color.is_a? Hash
        colors = color.values
      else
        colors = [color]
      end
      colors.each do |color|
        color.alpha = val
      end
    end
  end
end

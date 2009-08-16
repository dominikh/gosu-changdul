class Cursor
  attr_reader :img, :visible, :imgObj
  def initialize(window,img,visible)
    @window = window
    @img=img
    @visible=visible
    @imgObj=Gosu::Image.new(window,img,true)
    @forced=false
  end

  def toggleVisible
    if not @forced
      @visible=!visible
    end
  end

  def forceVisible
    @forced=true
    @visible=true
  end

  def unforceVisible
    @forced=false
  end

  def visible?
    return visible
  end

  def draw
    if @visible
      @imgObj.draw(@window.mouse_x,@window.mouse_y,999)
    end
  end
end

class WidgetList < Array
  def <<(widget)
    widget.zorder = max_zorder + 1
    super
  end

  def max_zorder
    m = map(&:zorder).max || 0
  end

  def set_active(widget)
    return if widget.active?
    return if not widget.selectable?
    old_widget = find(&:active?)
    old_widget.active = false  if old_widget
    widget.zorder = max_zorder + 1
    widget.active = true

    last_zorder = 0

    # what we are doing here:
    # 1) we are getting every widget (likely to # be a window) in its current order
    # 2) widget gets an zorder incremented by one from the last one
    # 3) all widgets in that widget will also set their zorder based on their relative one and the one of the widget
    # 4) we now also add the highest zorder of any widget's widgets to the counter
    sort_by(&:zorder).each do |widget|
      last_zorder += 1
      widget.zorder = last_zorder
      if widget.respond_to? :widgets
        last_zorder = widget.widgets.map(&:zorder).max
      end
    end
  end
end

module ApplicationHelper
  # Allowed size values: 18, 24, 36, 48
  def icon(name, size = 24)
    content_tag(:i, name, class: "icon material-icons md-#{size}")
  end
end

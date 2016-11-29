module ApplicationHelper
  # Allowed size values: 18, 24, 36, 48
  def icon(name, size = 24)
    content_tag(:i, "", class: "icon icon-#{size} mdi mdi-#{name}")
  end
end

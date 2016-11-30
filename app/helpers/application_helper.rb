module ApplicationHelper
  # Allowed size values: 18, 24, 36, 48
  def icon(name, size = 24)
    content_tag(:i, "", class: "icon icon-#{size} mdi mdi-#{name}")
  end

  def text_helpers(helpers = Array.new)
    content_tag(:div, class: "text-helpers pull-right") do
      buff = ""
      buff << content_tag(:strong, "Fix formatting: ", data: { balloon: "Sometimes imported recipes will need a little help to be formatted correctly.", balloon_length: "large" })
      buff << link_to(icon("format-list-numbers"), "javascript:void(0)", class: "remove-step-numbers", data: { balloon: "Remove step numbers" }) if helpers.include?("step-numbers")
      buff << link_to(icon("table-row-remove"), "javascript:void(0)", class: "remove-double-spaces", data: { balloon: "Remove extra spaces" }) if helpers.include?("double-spaces")
      buff << link_to(icon("playlist-remove"), "javascript:void(0)", class: "remove-line-breaks", data: { balloon: "Remove extra line breaks" }) if helpers.include?("line-breaks")
      buff.html_safe
    end
  end

end

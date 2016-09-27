module RecipesHelper
  def definition(term, definition)
    unless definition.nil? || definition.empty?
      content_tag(:dt, term) +
      content_tag(:dd, definition)
    end
  end

  def ingredient_formatter(ingredient)
    if ingredient.start_with?("##")
      html = "</ul><strong>" + ingredient.gsub("##", "") + "</strong><ul>"
      html.html_safe
    else
      content_tag :li, ingredient
    end
  end
end

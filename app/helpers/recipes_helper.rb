module RecipesHelper
  def definition(term, definition)
    unless definition.nil? || definition.empty?
      content_tag(:dt, term) +
      content_tag(:dd, definition)
    end
  end
end

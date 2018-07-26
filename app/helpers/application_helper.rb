module ApplicationHelper
  def full_title(page_title)
    subtitle = "Tenacious Track"
    if page_title.empty?
      subtitle
    else
      "#{page_title} | #{subtitle}"
    end
  end
end

require 'sessions_helper.rb'

module ApplicationHelper
  def full_title(page_title)
    subtitle = "Tenacious Track"
    if page_title.empty?
      subtitle
    else
      "#{page_title} | #{subtitle}"
    end
  end

  def user_or_login
    current_user ? user_path(current_user) : login_path
  end


end

module LoginMacros
  def set_user_session(user)
    @user = user
    session[:user_id] = user.id
  end

  def login(user)
    visit root_path
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
    click_button "Log in"
  end
end

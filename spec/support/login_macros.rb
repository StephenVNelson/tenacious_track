module LoginMacros
  def set_user_session(user)
    @user = user
    session[:user_id] = user.id
  end
end

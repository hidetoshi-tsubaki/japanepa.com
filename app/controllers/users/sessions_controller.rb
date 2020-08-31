class Users::SessionsController < Devise::SessionsController
  private

  def reset_session_before_login
    user_return_to = session[:user_return_to]
    reset_session
    session[:user_return_to] = user_return_to if user_return_to
  end
end

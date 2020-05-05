class Users::OmniauthCallbacksController < ApplicationController

  def facebook
    omniauth_callback
  end

  def twitter
    omniauth_callback
  end

  def omniauth_callback
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))
    if @user.persisted?
      set_user_total_experience(@user)
      sign_in_and_redirect @user
    else
      session["devise.user_attributes"] = @user.attributes
      redirect_to new_user_registration_url
    end
  end
end

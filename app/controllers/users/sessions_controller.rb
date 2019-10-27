# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :reset_session_before_login, only: [ :create ]
  # skip_before_action :verify_authenticity_token, only: [ :new ]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  private

  def reset_session_before_login
    user_return_to = session[:user_return_to]
    reset_session
    session[:user_return_to] = user_return_to if user_return_to
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

end

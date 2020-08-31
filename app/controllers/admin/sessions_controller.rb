class Admin::SessionsController < Devise::SessionsController
  before_action :authenticate_admin!, only: :destroy

  def new
    super
  end

  def destroy
    super
  end

  protected

  def after_sign_in_path_for(resource)
    if session[:previous_url] == "/admin/"
      super
    else
      session[:previous_url] || "/admin/"
    end
  end
end

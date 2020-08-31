class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_action, unless: :devise_controller?

  def after_sign_in_path_for(resource)
    if session[:previous_url] == root_path(resource)
      super
    else
      session[:previous_url] || root_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def get_needed_experience(user)
    @needed_experience_to_next_level = Level.find(user.level).threshold - user.user_experience.total_point
  end

  def get_unchecked_announce_count
    return unless user_signed_in?
    user_registration_date = current_user.created_at
    @unchecked_announce_count = Announcement.
      where("created_at > ?", user_registration_date).where(status: true).
      length - current_user.announcement_checks.length
  end

  def get_not_done_reviews_count
    return unless user_signed_in?
    @not_done_reviews_count = current_user.reviews_today.length
  end

  private

  def configure_permitted_parameters
    added_attrs = [:name, :country, :current_address, :password, :password_confirmation, :img, :delete_img]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:name, :password) }
  end

  def store_action
    return if current_user
    store_location_for(:user, request.url) if request.get?
  end

  def only_login_user!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: 'Please Log in '
    end
  end

  def authenticate_admin!
    unless admin_signed_in?
      redirect_to root_path, alert: 'Are you Admin user?'
    end
  end

  def only_private_user
    user = User.find(params[:id])
    unless user.id == current_user
      redirect_to root_path, alert: "You can't access ..."
    end
  end

  def admin_root
    if admin_signed_in?
      redirect_to "/admin/"
    end
  end

  def set_user_total_experience(user)
    UserExperience.create(user_id: user.id)
  end
end

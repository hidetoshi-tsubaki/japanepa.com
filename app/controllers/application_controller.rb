class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_action, unless: :devise_controller?

  def after_sign_in_path_for(resource)
    if (session[:previous_url] == root_path(resource))
      super
    else
      session[:previous_url] || root_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def get_user_level
    user_experience = current_user.user_experience
    @current_experience = user_experience.total_point
    @current_level = Level.where("threshold <= ?", @current_experience).order(threshold: :desc).limit(1).pluck(:id).first
    next_level = Level.where("threshold > ?", @current_experience).first
    @needed_experience_to_next_level = next_level.threshold - @current_experience
  end

  private

  def configure_permitted_parameters
    added_attrs = [:name, :country, :current_address, :password, :password_confirmation, :img]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:name, :password) }
  end

  def store_action
    return if current_user
    store_location_for(:user, request.url) if request.get?
  end

  # def authenticate_user!(user)
  #   puts user
  #   if user_signed_in?
  #     super
  #   else
  #     redirect_to new_user_session_path, alert: 'Please Log in '
  #   end
  # end

  def authenticate_admin!
    unless admin_signed_in?
      redirect_to root_path, alert: 'Are you Admin user?'
    end
  end
  

  def admin_root
    if admin_signed_in?
      redirect_to "/admin/"
    end
  end

  def set_user_total_experience(user)
    user_total_experience = UserExperience.new(user_id: user.id)
    user_total_experience.save!
  end
end

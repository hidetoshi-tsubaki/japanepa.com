class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_action
  protect_from_forgery with: :exception

  # @n5_quiz = [
  #   { "Character(もじ)": %w(あ→A ア→A) }, { "Word(ことば)": %w(Noun1 Noun2) }
  # ]
  # @n5Quiz= ["Character(もじ)": %w(あ→A ア→A あ→ア ア→あ A→あ A→ア),
  # "Word(ことば)": %w(Noun1 Noun2 Noun3 Noun4 Noun5 Time1 Time2 Verb1 Verb2 Adjective1 Adjective2 Interrogative),
  # "Kanji(かんじ)": %w(part1 part2 part3 part4 part5)]

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

  private

  def configure_permitted_parameters
    added_attrs = [:email, :name, :country, :current_address, :password, :password_confirmation, :img, :remove_img]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  def store_action
    return if current_user
    store_location_for(:user, request.url)
  end
end

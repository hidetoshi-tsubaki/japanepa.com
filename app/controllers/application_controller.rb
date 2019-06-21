class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include SessionsHelper
  protect_from_forgery with: :exception

  @n5Quiz= [{"Character(もじ)": %w(あ→A ア→A)},
            {"Word(ことば)": %w(Noun1 Noun2)}]

   # @n5Quiz= ["Character(もじ)": %w(あ→A ア→A あ→ア ア→あ A→あ A→ア),
    #           "Word(ことば)": %w(Noun1 Noun2 Noun3 Noun4 Noun5 Time1 Time2 Verb1 Verb2 Adjective1 Adjective2 Interrogative),
    #           "Kanji(かんじ)": %w(part1 part2 part3 part4 part5)]

    protected

    
  def configure_permitted_parameters
    added_attrs = [ :email, :name, :country, :current_address, :password, :password_confirmation ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

end

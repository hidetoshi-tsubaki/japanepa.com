module System
  module SessionHelpers
    def user_sign_up_with(name, country, address, email, password, password_confirmation)
      visit new_user_registration_path
      fill_in 'Name', with: name
      fill_in 'Country', with: country
      fill_in 'Address', with: address
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password_confirmation
      click_button 'Sign Up'
    end

    def user_sign_in(name, password)
      visit new_user_session_path
      fill_in 'Name', with: name
      fill_in 'Password', with: password
      click_button 'Log in'
    end

    def admin_sign_in(name, password)
      visit new_admin_session_path
      fill_in 'Name', with: name
      fill_in 'Password', with: password
      click_on 'Admin Login'
    end
  end
end

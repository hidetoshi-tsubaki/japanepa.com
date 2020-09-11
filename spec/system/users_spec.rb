require 'rails_helper'
RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }
  let!(:experience1) { create(:user_experience, user_id: user.id, total_point: 100) }
  let!(:user2) { create(:user) }
  let!(:experience2) { create(:user_experience, user_id: user2.id, total_point: 1) }

  before do
    create_list(:level, 10)
  end

  context "when user signed in" do
    it 'All function work normally', retry: 3 do
      user_sign_in(user.name, 'japanepa')
      visit ranking_path

      # rankingページの表示
      expect(page).to have_content 'Ranking'
      expect(page).to have_content user.name
      expect(page).to have_content user2.name

      # プロフィールページの表示
      first(".user_wrapper").click
      expect(page).to have_content user.name
      expect(page).to have_no_content user2.name
      expect(page).to have_content 'Total Play Count'

      # プロフィール変更ができる
      first(:link, 'Edit Your Profile').click
      expect(page).to have_content '~ Change Profile ~'
      fill_in 'Name', with: 'update-name'
      click_on 'Change'
      expect(page).to have_no_content 'Chage Profile'
      expect(page).to have_content 'update-name'

      # 退会できる
      expect(User.count).to eq 2
      first(:link, 'delete your account').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "Welcome to Japanepa.com"
      expect(User.count).to eq 1
    end
  end

  context "when user didn't sign in" do
    it "can't access ranking page" do
      visit ranking_path
      expect(page).to have_content "Log In"
    end

    it "can't access profile page" do
      visit user_path(user)
      expect(page).to have_content "Log In"
    end
  end
end

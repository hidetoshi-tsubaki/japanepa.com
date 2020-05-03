require 'rails_helper'
RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }

  before do
    create_list(:level, 10)
    user_sign_in(user.name, 'password')
    visit ranking_path
  end

  it 'All function work normally' do
    # rankingページの表示
    using_wait_time 10 do
      expect(page).to have_content 'Ranking'
    end
    expect(page).to have_content user.name
    expect(page).to have_content user2.name

    # プロフィールページの表示
    find('#top_1').click
    expect(page).to have_content 'Edit Your Profile'
    expect(page).to have_content user.name
    expect(page).to have_no_content user2.name
    expect(page).to have_content 'Total Play Count'

    # プロフィール変更ができる
    click_on 'Edit Your Profile'
    expect(page).to have_content 'Change Profile'
    fill_in 'Name', with: 'update-name'
    click_on 'Change'
    expect(page).to have_no_content 'Chage Profile'
    expect(page).to have_content 'update-name'
  end
end

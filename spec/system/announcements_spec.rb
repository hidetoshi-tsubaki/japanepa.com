require 'rails_helper'

RSpec.describe 'Announcement', type: :system do
  let!(:user) { create(:user) }
  let!(:announce1) { create(:announcement) }
  let!(:announce2) { create(:announcement, status: 'draft') }

  before do
    user_sign_in(user.name, 'password')
    visit root_path
  end

  it 'All function work normally' do
    # 未読のannouncement の数が表示される
    using_wait_time 15 do
      within '.announce_link_box' do
        expect(page).to have_content '1'
      end
    end
    find('.announce_link').click

    # 一覧表示
    expect(page).to have_content 'announce1'
    expect(page).to have_no_content 'announce2'

    # 未読のannouncementにはNEWが表示される
    expect(page).to have_content 'NEW'

    # 詳細を表示
    find(".show_announce_#{announce1.id}").click
    expect(page).to have_content announce1.contents
    visit announcements_path

    # 既読のannouncementにNEWが表示されない
    expect(page).to have_no_content 'NEW'
  end
end

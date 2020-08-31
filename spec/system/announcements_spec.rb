require 'rails_helper'

RSpec.describe 'Announcements', type: :system do
  let!(:user) { create(:user, :with_related_model) }
  let!(:announce1) { create(:announcement) }
  let!(:announce2) { create(:announcement, status: 'draft') }

  before do
    create_list(:level, 10)
  end

  it 'All function work normally', retry: 5 do
    user_sign_in(user.name, 'japanepa')
    visit root_path
    # 未読のannouncement の数が表示される
    expect(page).to have_content user.name
    within '.header_link' do
      within '.announce_btn' do
        expect(page).to have_content '1'
      end
    end

    # 一覧表示
    within '.announce_btn' do
      first(:link, '1').click
    end

    using_wait_time 25 do
      expect(page).to have_content announce1.title
      expect(page).to have_content "NEW"
      # 未公開のannounceは表示されない
      expect(page).to have_no_content announce2.title
    end

    # 詳細ページ表示
    first(".announce_#{announce1.id}").click
    using_wait_time 10 do
      expect(page).to have_content announce1.contents
    end

    visit announcements_path
    expect(page).to have_no_content "NEW"
  end
end

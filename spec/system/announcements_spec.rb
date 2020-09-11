require 'rails_helper'

RSpec.describe 'Announcements', type: :system do
  let!(:user) { create(:user, :with_related_model) }

  before do
    create_list(:level, 10)
    travel_to(Date.tomorrow) do
      @latest_announce = create(:announcement, title: 'latest')
      @draft_announce = create(:announcement, title: 'draft', status: 'draft')
    end
  end

  it 'All function work normally', retry: 2 do
    user_sign_in(user.name, 'japanepa')
    visit root_path
    # 未読のannouncement の数が表示される
    within '.header_link' do
      within '.announce_btn' do
        expect(page).to have_content '1'
      end
    end

    # 一覧表示
    within '.header_link' do
      within '.announce_btn' do
        find('.announce_link').click
      end
    end
    visit announcements_path
    expect(page).to have_content @latest_announce.title
    expect(page).to have_content "NEW"
    expect(page).to have_no_content @draft_announce.title

    # 詳細ページ表示
    first(".announce_#{@latest_announce.id}").click
    visit announcement_path @latest_announce
    expect(page).to have_content @latest_announce.contents

    # 既読のannounceにはnewがつかない
    visit announcements_path
    expect(page).to have_no_content "NEW"
  end
end

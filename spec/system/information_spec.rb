require 'rails_helper'

RSpec.describe 'Information', type: :system do
  let!(:user) { create(:user) }
  let!(:info1) { create(:information) }
  let!(:info2) { create(:information, status: 'draft') }

  before do
    user_sign_in(user.name, 'password')
    visit root_path
  end

  it 'All function work normally' do
    # 未読のinformation の数が表示される
    using_wait_time 15 do
      within '.info_link_box' do
        expect(page).to have_content '1'
      end
    end
    find('.info_link').click

    # 一覧表示
    expect(page).to have_content 'info1'
    expect(page).to have_no_content 'info2'

    # 未読のinformationにはNEWが表示される
    expect(page).to have_content 'NEW'

    # 詳細を表示
    find(".show_info_#{info1.id}").click
    expect(page).to have_content info1.contents
    visit information_index_path

    # 既読のinformationにNEWが表示されない
    expect(page).to have_no_content 'NEW'
  end
end

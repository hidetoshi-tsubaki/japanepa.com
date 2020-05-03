require 'rails_helper'

RSpec.describe 'Community', type: :system do
  let!(:user) { create(:user) }
  let!(:community) { create(:community, founder_id: user.id) }

  before do
    user_sign_in(user.name, 'password')
    visit communities_path
  end

  it 'All functions work normally' do
    using_wait_time 20 do
      expect(page).to have_content 'Community Index'
    end

    # community 作成
    find('#create_community_btn').click
    using_wait_time 20 do
      expect(page).to have_content 'Create New Community'
    end

    find('#input_community_name').set('new community')
    find('#input_community_introduction').set('this is introduction')
    click_on 'Create'

    # community 詳細
    using_wait_time 10 do
      expect(page).to have_content 'Founder'
      expect(page).to have_css '#top_create_talk_btn'
    end

    # community 編集
    find('#edit_community_btn').click
    expect(page).to have_content 'Edit Community Form'
    fill_in 'input_community_name', with: 'update community'
    click_on 'Update'

    # community 削除
    find('#edit_community_btn').click
    using_wait_time 10 do
      find('#delete_community_btn').click
    end
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'Community Index'
    expect(page).to have_no_content 'update community'
  end
end

require 'rails_helper'

RSpec.describe 'Community', type: :system do
  let!(:user) { create(:user) }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:community2) { create(:community, founder_id: user.id) }
  let!(:community_user) { create(:community_user, user_id: user.id, community_id: community.id) }

  it 'All functions work normally', retry: 5 do
    user_sign_in(user.name, 'japanepa')
    visit communities_path

    # community 一覧
    using_wait_time 20 do
      expect(page).to have_content 'Communities Index'
    end

    # community 作成
    find(:link, 'create community').click
    using_wait_time 25 do
      expect(page).to have_content 'Create Community'
    end
    find('#input_community_name').set('new community')
    find('#input_community_introduction').set('this is introduction')
    click_on 'Create'

    # community 詳細
    using_wait_time 10 do
      expect(page).to have_content 'Founder'
      expect(page).to have_css '.create_talk_btn'
    end

    # community 編集
    find('#edit_community_btn').click
    expect(page).to have_content 'Edit Community'
    find('#input_community_name').set('update community')
    click_on 'Update'
    using_wait_time 10 do
      expect(page).to have_content 'update community'
    end

    # community 削除
    find('#edit_community_btn').click
    using_wait_time 20 do
      find('.delete_btn').click
    end
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content 'Communities Index'
    expect(page).to have_no_content 'update community'

    # community 検索
    find('.search_input').set(community.name)
    find('.search_btn').click
    within '.main_section' do
      expect(page).to have_content community.name
      expect(page).to have_no_content community2.name
    end
    find('.search_input').set('wrong-keyword')
    find('.search_btn').click
    expect(page).to have_content 'No community...'
  end
end

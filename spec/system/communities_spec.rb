require 'rails_helper'

RSpec.describe 'Community', type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:community2) { create(:community, founder_id: user2.id) }
  let!(:community_user) { create(:community_user, user_id: user.id, community_id: community.id) }

  it 'All functions work normally', retry: 2 do
    user_sign_in(user.name, 'japanepa')
    visit communities_path

    # community 一覧
    expect(page).to have_content 'Communities Index'

    # community 作成
    first('.create_community_btn').click
    visit new_community_path
    expect(page).to have_content 'Create Community'
    find('#input_community_name').set('new_community')
    find('#input_community_introduction').set('this is introduction')
    click_on 'Create'
    visit communities_path
    expect(page).to have_content 'new_community'

    # community 詳細
    find("#community_#{community.id}").click
    visit community_path community
    expect(page).to have_content community.founder.name

    # community 編集
    first('.edit_community_btn').click
    visit edit_community_path community
    expect(page).to have_content 'Edit Community'
    find('#input_community_name').set('update community')
    click_on 'Update'
    visit communities_path
    expect(page).to have_content 'update community'

    # community 削除
    find("#community_#{community.id}").click
    visit community_path community
    first('.edit_community_btn').click
    visit edit_community_path community
    first('.delete_btn').click
    visit communities_path
    expect(page).to have_no_content 'update community'

    # 他人のcommunity編集画面は表示されない
    visit community_path community2
    expect(page).to have_no_content 'Edit'
    visit edit_community_path community2
    expect(page).to have_content "You don't have the authority"

    # community 検索
    first('.search_input').set('new_community')
    first('.search_btn').click
    using_wait_time 20 do
      within '.main_section' do
        expect(page).to have_content 'new_community'
        expect(page).to have_no_content community2.name
      end
    end
    first('.search_input').set('wrong-keyword')
    first('.search_btn').click
    expect(page).to have_content 'No community...'
  end
end

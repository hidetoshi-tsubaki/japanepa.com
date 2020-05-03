require 'rails_helper'
RSpec.describe 'Talks', type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:community) { create(:community) }
  let!(:community2) { create(:community) }
  let!(:community_user) { create(:community_user, community_id: community.id, user_id: user.id) }
  let!(:community_user2) { create(:community_user, community_id: community.id, user_id: user2.id) }
  let!(:talk) { create(:talk, community_id: community.id, user_id: user.id) }
  let!(:talk2) { create(:talk, community_id: community.id, user_id: user2.id) }

  before do
    user_sign_in(user.name, "password")
    visit feed_talk_path user
  end

  it 'All functions work normally' do
    using_wait_time 10 do
      expect(page).to have_content 'Feed'
    end
    expect(page).to have_content talk.content

    # talk作成
    click_on 'Create Talk'
    using_wait_time 10 do
      expect(page).to have_content 'Talk Form'
    end
    fill_in 'talk_content_input', with: 'new-talk'
    click_on 'Post'
    expect(page).to have_content 'new-talk'

    # talkの編集
    within '#talk_1' do
      find('.fa-edit').click
    end

    using_wait_time 10 do
      expect(page).to have_content 'Talk Form'
      expect(page).to have_content 'Upload'
    end

    fill_in 'talk_content_input', with: 'updated-talk'
    click_on 'Update'

    using_wait_time 10 do
      expect(page).to have_content 'updated-talk'
    end

    # talkの削除
    within '#talk_1' do
      find('.fa-trash-alt').click
    end
    page.driver.browser.switch_to.alert.accept

    using_wait_time 10 do
      within '.main_section' do
        expect(page).to have_no_content 'updated-talk'
      end
    end

    # いいねボタン
    expect(LikeTalk.count).to eq 0

    within '#talk_2' do
      find('.far').click

      using_wait_time 10 do
        expect(page).to have_css '.fas'
        expect(page).to have_no_css '.far'
      end
    end

    expect(LikeTalk.count).to eq 1
  end
end

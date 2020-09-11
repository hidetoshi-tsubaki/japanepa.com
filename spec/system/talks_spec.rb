require 'rails_helper'
RSpec.describe 'Talks', type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:community2) { create(:community, :with_founder) }
  let!(:community_user) { create(:community_user, community_id: community.id, user_id: user.id) }
  let!(:talk) { create(:talk, community_id: community.id, user_id: user.id) }
  let!(:talk2) { create(:talk, community_id: community.id, user_id: user2.id) }
  let!(:talk3) { create(:talk, community_id: community2.id, user_id: user2.id) }

  context "when user signed in" do
    before do
      user_sign_in(user.name, "japanepa")
      visit feed_talks_path
    end

    it 'All functions work normally', js: true, retry: 2 do
      expect(page).to have_content 'Feed'
      within '.talk_index_wrapper' do
        expect(page).to have_content talk.content
        expect(page).to have_no_content talk3.content
      end

      # talk作成
      first('.create_talk_btn').click
      visit new_talk_path(from_community_page: community.id)
      expect(page).to have_content 'Create Talk'
      find('.content_input').set('new-talk')
      click_on 'Post'
      visit community_path community
      expect(page).to have_content 'new-talk'

      # talkの編集
      first(:link, 'Edit').click
      visit edit_talk_path talk
      expect(page).to have_content 'Edit Talk'
      find('.content_input').set('updated-talk')
      click_on 'Update'
      visit community_path community
      expect(page).to have_content 'updated-talk'

      # talkの削除
      first(:link, 'Delete').click
      page.driver.browser.switch_to.alert.accept
      visit community_path community
      within '.main_section' do
        expect(page).to have_no_content 'new-talk'
      end

      # いいねボタン
      expect(talk2.likes_count).to eq 0
      within "#talk_#{talk2.id}" do
        find(:link, "0").click
      end
      visit community_path community
      within "#talk_#{talk2.id}" do
        expect(page).to have_content "1"
      end

      # いいね解除
      within "#talk_#{talk2.id}" do
        find(:link, "1").click
      end
      visit community_path community
      within "#talk_#{talk2.id}" do
        expect(page).to have_content "0"
      end
    end
  end
end

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

    it 'All functions work normally', retry: 3 do
      expect(page).to have_content 'Feed'
      within '.talk_index_wrapper' do
        expect(page).to have_content talk.content
        expect(page).to have_no_content talk3.content
      end

      # talk作成
      within ".side_section" do
        first(:link, 'Create talk').click
      end
      using_wait_time 25 do
        expect(page).to have_content 'Create Talk'
      end
      find('.content_input').set('new-talk')
      click_on 'Post'
      expect(page).to have_content 'new-talk'

      # talkの編集
      first(:link, 'Edit').click

      using_wait_time 25 do
        expect(page).to have_content 'Edit Talk'
        expect(page).to have_content 'Upload'
      end

      find('.content_input').set('updated-talk')
      click_on 'Update'

      using_wait_time 10 do
        expect(page).to have_content 'updated-talk'
      end

      # talkの削除
      first(:link, 'Delete').click
      page.driver.browser.switch_to.alert.accept

      using_wait_time 10 do
        within '.main_section' do
          expect(page).to have_no_content 'updated-talk'
        end
      end

      # いいねボタン
      expect(talk2.likes_count).to eq 0
      within "#talk_#{talk2.id}" do
        find(:link, "0").click
      end
      using_wait_time 20 do
        within "#talk_#{talk2.id}" do
          expect(page).to have_content "1"
        end
      end

      # いいね解除
      within "#talk_#{talk2.id}" do
        find(:link, "1").click
      end
      using_wait_time 20 do
        within "#talk_#{talk2.id}" do
          expect(page).to have_content "0"
        end
      end
    end
  end
end
